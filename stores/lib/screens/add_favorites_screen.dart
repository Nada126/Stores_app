import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart'; // Import your Store class
import '../../../providers/store_provider.dart'; // Import your StoreProvider class
import 'favorites_screen.dart'; // Import the FavoritesScreen

class AddToFavoritesScreen extends StatelessWidget {
  const AddToFavoritesScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final storeProvider = Provider.of<StoreProvider>(context);
    List<Store> stores = storeProvider.stores; // Assuming you have a list of stores

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
              onTap: () {
                // Get the user's email (replace with your actual logic to retrieve the user's email)
                String userEmail = 'user@example.com';
                
                // Call function to add store to favorites
                storeProvider.addFavorite(userEmail, store.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${store.name} added to favorites'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate back to previous screen
          Navigator.pop(context);
          // Then navigate to FavoritesScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesScreen()),
          );
        },
        child: Icon(Icons.favorite),
      ),
    );
  }
}