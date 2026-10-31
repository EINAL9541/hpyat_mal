import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/features/forest/_provider/forest_provider.dart';

class JournalState {
  final List<CravingLog> logs;

  const JournalState({this.logs = const []});

  int get totalCravings => logs.length;
  int get resistedCount => logs.where((l) => l.resisted).length;
  int get slipCount => logs.where((l) => !l.resisted).length;
  double get resistanceRate =>
      totalCravings == 0 ? 100.0 : (resistedCount / totalCravings) * 100.0;

  List<CravingLog> get resistedLogs => logs.where((l) => l.resisted).toList();
  List<CravingLog> get slipLogs => logs.where((l) => !l.resisted).toList();

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
      await ref.read(forestProvider.notifier).boostVitality();
    } else {
      await ref.read(forestProvider.notifier).recordSlip();
    }

    state = JournalState(logs: storage.getCravingLogs());
  }

  Future<void> updateCravingLog({
    required CravingLog existing,
    required String trigger,
    required int intensity,
    required bool resisted,
    required String note,
  }) async {
    final storage = ref.read(storageServiceProvider);
    final updated = existing.copyWith(
      trigger: trigger,
      intensity: intensity,
      resisted: resisted,
      note: note,
    );
    await storage.updateCravingLog(updated);
    state = JournalState(logs: storage.getCravingLogs());
  }

  Future<void> deleteCravingLog(String id) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteCravingLog(id);
    state = JournalState(logs: storage.getCravingLogs());
  }
}

final journalProvider =
    NotifierProvider<JournalNotifier, JournalState>(JournalNotifier.new);
