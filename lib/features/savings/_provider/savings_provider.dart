import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';

class SavingsState {
  final List<WishlistItem> wishlist;

  const SavingsState({this.wishlist = const []});
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
  }) async {
    final storage = ref.read(storageServiceProvider);
    final item = WishlistItem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      targetAmount: targetAmount,
      iconKey: iconKey,
    );
    await storage.saveWishlistItem(item);
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
