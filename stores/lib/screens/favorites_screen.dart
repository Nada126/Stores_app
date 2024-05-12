import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../notifiers/favorite_store_notifier.dart';
import '../providers/store_provider.dart';
import '../models/store.dart';
import 'distance_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final favoriteStoreNotifier = Provider.of<FavoriteStoreNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteStoreNotifier.favoriteStores.length,
        itemBuilder: (context, index) {
          final store = favoriteStoreNotifier.favoriteStores[index];
          return ListTile(
            title: Text(store.name),
            onTap: () => _removeFavorite(store),
            trailing: ElevatedButton(
              onPressed: () => _navigateToDistanceScreen(context, store),
              child: const Text('Calculate Distance'),
            ),
          );
        },
      ),
    );
  }


  void _navigateToDistanceScreen(BuildContext context, Store store) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DistanceScreen(store: store)),
    );
  }
}
