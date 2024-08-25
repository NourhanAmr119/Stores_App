import 'package:flutter/material.dart';
import '../models/store.dart';

class FavoriteStoreNotifier with ChangeNotifier {
  List<Store> _favoriteStores = [];

  List<Store> get favoriteStores => _favoriteStores;

  void addFavoriteStore(Store store) {
    _favoriteStores.add(store);
    notifyListeners();
  }

  void removeFavoriteStore(Store store) {
    _favoriteStores.remove(store);
    notifyListeners();
  }

  // Add _addFavorite method here
  void _addFavorite(BuildContext context, Store store) async {
    // Add to favorites logic...
    addFavoriteStore(store); // Call the existing method to add the store to favorites
  }
}
