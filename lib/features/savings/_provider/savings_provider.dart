import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';

class SavingsState {
  final List<WishlistItem> wishlist;

  const SavingsState({this.wishlist = const []});

  List<WishlistItem> get activeItems =>
      wishlist.where((item) => !item.isCompleted).toList();

  List<WishlistItem> get completedItems =>
      wishlist.where((item) => item.isCompleted).toList();

  double get claimedTotal => completedItems.fold(
        0.0,
        (sum, item) => sum + item.targetAmount,
      );
}

class SavingsNotifier extends Notifier<SavingsState> {
  @override
  SavingsState build() {
    final storage = ref.watch(storageServiceProvider);
    return SavingsState(wishlist: storage.getWishlist());
  }

  Future<void> addWishlistItem({
    required String title,
    required double targetAmount,
    required String iconKey,
    String? imagePath,
  }) async {
    final storage = ref.read(storageServiceProvider);
    final item = WishlistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      targetAmount: targetAmount,
      iconKey: iconKey,
      imagePath: imagePath,
    );
    await storage.saveWishlistItem(item);
    state = SavingsState(wishlist: storage.getWishlist());
  }

  Future<void> updateWishlistItem({
    required String id,
    required String title,
    required double targetAmount,
    required String iconKey,
    String? imagePath,
    required bool isCompleted,
  }) async {
    final storage = ref.read(storageServiceProvider);
    final updated = WishlistItem(
      id: id,
      title: title,
      targetAmount: targetAmount,
      iconKey: iconKey,
      imagePath: imagePath,
      isCompleted: isCompleted,
    );
    await storage.updateWishlistItem(updated);
    state = SavingsState(wishlist: storage.getWishlist());
  }

  Future<void> deleteItem(String id) async {
    final storage = ref.read(storageServiceProvider);
    await storage.deleteWishlistItem(id);
    state = SavingsState(wishlist: storage.getWishlist());
  }

  Future<void> toggleItem(String id) async {
    final storage = ref.read(storageServiceProvider);
    await storage.toggleWishlistItem(id);
    state = SavingsState(wishlist: storage.getWishlist());
  }
}

final savingsProvider =
    NotifierProvider<SavingsNotifier, SavingsState>(SavingsNotifier.new);
