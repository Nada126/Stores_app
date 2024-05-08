import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import '../../../providers/store_provider.dart';
import 'favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToFavoritesScreen extends StatelessWidget {
  const AddToFavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    List<Store> stores = storeProvider.stores;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Store to Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            Store store = stores[index];
            return ListTile(
              title: Text(store.name),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                String? userEmail = prefs.getString('user_email');

                if (userEmail != null) {
                  // Call function to add store to favorites
                  await storeProvider.addFavorite(userEmail, store.id);

                  // Notify listeners of changes
                  storeProvider.getFavorites(userEmail);

                  // Update shared preferences
                  List<String> favoriteStoreIds = prefs.getStringList(userEmail) ?? [];
                  favoriteStoreIds.add(store.id.toString());
                  prefs.setStringList(userEmail, favoriteStoreIds);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${store.name} added to favorites'),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Navigate back to the previous screen
                  Navigator.pop(context);
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
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the FavoritesScreen
          Navigator.pushReplacementNamed(context, '/favorites');
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}
