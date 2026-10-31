import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';

enum BreathPhase { ready, inhale, hold, exhale, completed }

class BreathingState {
  final BreathPhase phase;
  final int secondsLeftInPhase;
  final int totalPhaseDuration;
  final int currentCycle;
  final int totalCycles;
  final bool isRunning;
  final int completedSessions;

  const BreathingState({
    this.phase = BreathPhase.ready,
    this.secondsLeftInPhase = 4,
    this.totalPhaseDuration = 4,
    this.currentCycle = 1,
    this.totalCycles = 4,
    this.isRunning = false,
    this.completedSessions = 0,
  });

  double get phaseProgress {
    if (totalPhaseDuration == 0) return 0;
    return (totalPhaseDuration - secondsLeftInPhase) / totalPhaseDuration;
  }

  String get instruction {
    switch (phase) {
      case BreathPhase.ready:
        return LocaleKeys.breathing_instructReady.tr();
      case BreathPhase.inhale:
        return LocaleKeys.breathing_instructInhale.tr();
      case BreathPhase.hold:
        return LocaleKeys.breathing_instructHold.tr();
      case BreathPhase.exhale:
        return LocaleKeys.breathing_instructExhale.tr();
      case BreathPhase.completed:
        return LocaleKeys.breathing_instructCompleted.tr();
    }
  }

  BreathingState copyWith({
    BreathPhase? phase,
    int? secondsLeftInPhase,
    int? totalPhaseDuration,
    int? currentCycle,
    int? totalCycles,
    bool? isRunning,
    int? completedSessions,
  }) {
    return BreathingState(
      phase: phase ?? this.phase,
      secondsLeftInPhase: secondsLeftInPhase ?? this.secondsLeftInPhase,
      totalPhaseDuration: totalPhaseDuration ?? this.totalPhaseDuration,
      currentCycle: currentCycle ?? this.currentCycle,
      totalCycles: totalCycles ?? this.totalCycles,
      isRunning: isRunning ?? this.isRunning,
      completedSessions: completedSessions ?? this.completedSessions,
    );
  }
}

class BreathingNotifier extends Notifier<BreathingState> {
  Timer? _timer;

  @override
  BreathingState build() {
    final storage = ref.watch(storageServiceProvider);
    ref.onDispose(() {
      _timer?.cancel();
    });

    return BreathingState(
      completedSessions: storage.getBreathingSessions(),
    );
  }

  void startSession() {
    _timer?.cancel();
    HapticFeedback.mediumImpact();
    state = state.copyWith(
      phase: BreathPhase.inhale,
      secondsLeftInPhase: 4,
      totalPhaseDuration: 4,
      currentCycle: 1,
      isRunning: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void stopSession() {
    _timer?.cancel();
    HapticFeedback.selectionClick();
    state = state.copyWith(
      phase: BreathPhase.ready,
      isRunning: false,
      secondsLeftInPhase: 4,
      totalPhaseDuration: 4,
    );
  }

  void _tick() {
    if (state.secondsLeftInPhase > 1) {
      state = state.copyWith(secondsLeftInPhase: state.secondsLeftInPhase - 1);
      return;
    }

    // Transition between 4-7-8 stages with gentle haptic cue
    HapticFeedback.lightImpact();
    switch (state.phase) {
      case BreathPhase.inhale:
        state = state.copyWith(
          phase: BreathPhase.hold,
          secondsLeftInPhase: 7,
          totalPhaseDuration: 7,
        );
        break;
      case BreathPhase.hold:
        state = state.copyWith(
          phase: BreathPhase.exhale,
          secondsLeftInPhase: 8,
          totalPhaseDuration: 8,
        );
        break;
      case BreathPhase.exhale:
        if (state.currentCycle < state.totalCycles) {
          state = state.copyWith(
            phase: BreathPhase.inhale,
            currentCycle: state.currentCycle + 1,
            secondsLeftInPhase: 4,
            totalPhaseDuration: 4,
          );
        } else {
          _completeSession();
        }
        break;
      default:
        break;
    }
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    HapticFeedback.mediumImpact();
    final storage = ref.read(storageServiceProvider);
    await storage.incrementBreathingSessions();
    await ref.read(forestProvider.notifier).boostVitality();

    state = state.copyWith(
      phase: BreathPhase.completed,
      isRunning: false,
      completedSessions: storage.getBreathingSessions(),
    );
  }
}

final breathingProvider =
    NotifierProvider.autoDispose<BreathingNotifier, BreathingState>(
      BreathingNotifier.new,
    );
