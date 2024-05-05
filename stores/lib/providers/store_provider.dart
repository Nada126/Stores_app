import 'package:flutter/material.dart';
import '../../models/store.dart';

class StoreProvider extends ChangeNotifier {
  List<Store> _stores = []; // List of all stores
  List<Store> _favorites = []; // List of favorite stores

  // Getter to retrieve the list of stores
  List<Store> get stores => _stores;

  // Getter to retrieve the list of favorite stores
  List<Store> get favorites => _favorites;

  // Method to fetch stores from a database or other data source
  Future<void> fetchStores() async {
    // Simulated fetching of stores
    List<Store> fetchedStores = await _fetchStoresFromDatabase(); // Replace with actual data fetching logic
    
    // Update the stores list only if it's empty
    if (_stores.isEmpty) {
      _stores = fetchedStores;
      notifyListeners(); // Notify listeners after fetching the stores
    }
  }

  Future<List<Store>> _fetchStoresFromDatabase() async {
    // Simulated data fetching from a database
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay
    return [
      Store(id: 1, name: 'Store 1', latitude: 40.7128, longitude: -74.0060),
      Store(id: 2, name: 'Store 2', latitude: 34.0522, longitude: -118.2437),
      Store(id: 3, name: 'Store 3', latitude: 37.7749, longitude: -122.4194),
    ];
  }

  // Method to add a store to favorites
  void addFavorite(Store store) {
    if (!_favorites.contains(store)) {
      _favorites.add(store);
      notifyListeners(); // Notify listeners after updating favorites
    }
  }

  // Method to remove a store from favorites
  void removeFavorite(Store store) {
    _favorites.remove(store);
    notifyListeners(); // Notify listeners after updating favorites
  }
}