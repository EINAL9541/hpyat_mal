import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        return 'Tap to begin 4-7-8 calming breath';
      case BreathPhase.inhale:
        return 'Inhale slowly through your nose...';
      case BreathPhase.hold:
        return 'Hold your breath gently...';
      case BreathPhase.exhale:
        return 'Exhale completely through mouth...';
      case BreathPhase.completed:
        return 'Craving defused. Forest nourished!';
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

    // Transition between 4-7-8 stages
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
    final storage = ref.read(storageServiceProvider);
    await storage.incrementBreathingSessions();
    // Reward forest with vitality
    await ref.read(forestProvider.notifier).boostVitality();

    state = state.copyWith(
      phase: BreathPhase.completed,
      isRunning: false,
      completedSessions: storage.getBreathingSessions(),
    );
  }
}

final breathingProvider =
    NotifierProvider<BreathingNotifier, BreathingState>(BreathingNotifier.new);
