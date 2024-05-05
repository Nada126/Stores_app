import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart'; // Import your Store class
import '../../../providers/store_provider.dart'; // Import your StoreProvider class

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    List<Store> favoriteStores = storeProvider.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Stores'),
      ),
      body: ListView.builder(
        itemCount: favoriteStores.length,
        itemBuilder: (context, index) {
          Store store = favoriteStores[index];
          return ListTile(
            title: Text(store.name),
            subtitle: Text('Latitude: ${store.latitude}, Longitude: ${store.longitude}'),
            // Add other widgets or functionality as needed
          );
        },
      ),
    );
  }
}