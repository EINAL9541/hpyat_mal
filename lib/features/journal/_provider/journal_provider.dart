import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';

class JournalState {
  final List<CravingLog> logs;

  const JournalState({this.logs = const []});

  int get totalCravings => logs.length;
  int get resistedCount => logs.where((l) => l.resisted).length;
  double get resistanceRate =>
      totalCravings == 0 ? 100.0 : (resistedCount / totalCravings) * 100.0;

  Map<String, int> get triggerCounts {
    final map = <String, int>{};
    for (final log in logs) {
      map[log.trigger] = (map[log.trigger] ?? 0) + 1;
    }
    return map;
  }
}

class JournalNotifier extends Notifier<JournalState> {
  @override
  JournalState build() {
    final storage = ref.watch(storageServiceProvider);
    return JournalState(logs: storage.getCravingLogs());
  }

  Future<void> addCravingLog({
    required String trigger,
    required int intensity,
    required bool resisted,
    required String note,
  }) async {
    final storage = ref.read(storageServiceProvider);
    final newLog = CravingLog(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp: DateTime.now(),
      trigger: trigger,
      intensity: intensity,
      resisted: resisted,
      note: note,
    );

    await storage.saveCravingLog(newLog);

    if (resisted) {
      // Reward with vitality
      await ref.read(forestProvider.notifier).boostVitality();
    } else {
      // Soft slip - fog covers forest, encourage quick reset
      await ref.read(forestProvider.notifier).recordSlip();
    }

    state = JournalState(logs: storage.getCravingLogs());
  }
}

final journalProvider =
    NotifierProvider<JournalNotifier, JournalState>(JournalNotifier.new);
