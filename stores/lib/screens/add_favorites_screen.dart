import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/favorite_store_notifier.dart';
import '../providers/store_provider.dart';
import '../models/store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'distance_screen.dart';

class AddToFavoritesScreen extends StatelessWidget {
  const AddToFavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final favoriteStoreNotifier = Provider.of<FavoriteStoreNotifier>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Store to Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<StoreProvider>(
          builder: (context, storeProvider, _) {
            final List<Store> stores = storeProvider.stores;

            return ListView.builder(
              itemCount: stores.length,
              itemBuilder: (context, index) {
                final Store store = stores[index];

                return ListTile(
                  title: Text(store.name),
                  onTap: () async {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    String? userEmail = prefs.getString('user_email');

                    if (userEmail != null) {
                      bool isFavorite = await storeProvider.isStoreFavorited(userEmail, store.id);
                      if (!isFavorite) {
                        await storeProvider.addFavorite(userEmail, store.id);
                        favoriteStoreNotifier.addFavoriteStore(store); // Add to FavoriteStoreNotifier
                      } else {
                        await storeProvider.removeFavorite(userEmail, store.id);
                        favoriteStoreNotifier.removeFavoriteStore(store); // Remove from FavoriteStoreNotifier
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${store.name} ${!isFavorite ? 'added to' : 'removed from'} favorites'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User email not found. Please log in.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacementNamed(context, '/favorites');
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
