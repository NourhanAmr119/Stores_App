import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/store_provider.dart';
import '../models/store.dart';
import '../screens/distance_screen.dart';  

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<void> _favoritesLoader;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _favoritesLoader = _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('user_email');
    if (_userEmail != null) {
      await Provider.of<StoreProvider>(context, listen: false).getFavorites(_userEmail!);
    }
  }

  void _removeFavorite(Store store) async {
    if (_userEmail != null) {
      Provider.of<StoreProvider>(context, listen: false).removeFavorite(_userEmail!, store.id);
    }
  }

  void _navigateToDistanceScreen(BuildContext context, Store store) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DistanceScreen(store: store)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Favorites"),
      ),
      body: FutureBuilder(
        future: _favoritesLoader,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<StoreProvider>(
              builder: (context, provider, child) => ListView.builder(
                itemCount: provider.favorites.length,
                itemBuilder: (context, index) {
                  Store store = provider.favorites[index];
                  return ListTile(
                    title: Text(store.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min, // To prevent the row from taking full width
                      children: [
                        ElevatedButton(
                          onPressed: () => _navigateToDistanceScreen(context, store),
                          child: const Text('Calculate Distance'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _removeFavorite(store),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}