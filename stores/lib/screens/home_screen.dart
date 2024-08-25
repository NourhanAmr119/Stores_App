import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/store_provider.dart';
import '../models/store.dart';
import '../providers/user_provider.dart';
import 'add_favorites_screen.dart' as AddFavoritesScreen; // Import with alias
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store List'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          List<Store> stores = storeProvider.stores;
          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              Store store = stores[index];
              return ListTile(
                title: Text(store.name),
                subtitle: Text(
                  'Latitude: ${store.latitude}, Longitude: ${store.longitude}',
                ),
                onTap: () {
                  _toggleFavorite(context, store);
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddFavoritesScreen.AddToFavoritesScreen()), // Use the imported alias
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const FavoritesScreen()),
      );
    }
  }

  void _toggleFavorite(BuildContext context, Store store) async {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final userEmail = userProvider.currentUser.email;

    if (await storeProvider.isStoreFavorited(userEmail, store.id)) {
      await storeProvider.removeFavorite(userEmail, store.id);
    } else {
      await storeProvider.addFavorite(userEmail, store.id);
    }
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
  }
}