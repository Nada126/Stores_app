import 'package:flutter/material.dart';
import '../../../models/store.dart'; // Import your Store class

class AddToFavoritesScreen extends StatelessWidget {
  const AddToFavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Store to Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Store Name'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Dummy data for demonstration
                Map<dynamic, dynamic> storeData = {
                  'id': 1,
                  'name': 'Example Store',
                  'latitude': 40.7128,
                  'longitude': -74.0060
                };

                // Convert the map to Map<String, dynamic>
                Map<String, dynamic> storeDataStringKey = storeData.cast<String, dynamic>();

                // Create a Store object from the map
                Store store = Store.fromMap(storeDataStringKey);

                // Call function to add store to favorites
                addStoreToFavorite(context, store);
              },
              child: const Text('Add to Favorites'),
            ),
          ],
        ),
      ),
    );
  }

  void addStoreToFavorite(BuildContext context, Store store) {
    // Perform logic to add store to favorites here
    // For demonstration, just print the store name
    print('Added ${store.name} to favorites!');

    // You can also use a provider here to update the list of favorite stores
  }
}