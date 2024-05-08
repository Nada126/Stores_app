// import 'dart:indexed_db';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../models/store.dart';
import '../models/user_data.dart';

class StoreProvider extends ChangeNotifier {
  late Database _db;

  // Getter to retrieve the list of stores
  List<Store> _stores = [];
  List<Store> get stores => _stores;

  // Getter to retrieve the list of favorite stores for the current user
  List<Store> _favorites = [];
  List<Store> get favorites => _favorites;

  // Constructor
  StoreProvider() {
    initialize();
  }

  // Initialize the database and fetch stores
  Future<void> initialize() async {
    _db = await _initializeDatabase();
    await _createTables();
    _addDummyStores(); // Add dummy stores
    await fetchStores();
  }

  // Method to add dummy stores for testing
  void _addDummyStores() {
    _stores = [
      Store(id: 1, name: 'Store 1', latitude: 0.0, longitude: 0.0),
      Store(id: 2, name: 'Store 2', latitude: 0.0, longitude: 0.0),
      Store(id: 3, name: 'Store 3', latitude: 0.0, longitude: 0.0),
      // Add more dummy stores as needed
    ];
  }

  // Initialize the database
  Future<Database> _initializeDatabase() async {
    final String path = await getDatabasesPath();
    final String dbPath = join(path, 'stores.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        // Create tables when the database is first created
        await _createTables();
      },
    );
  }

  // Create necessary tables if they don't exist
  Future<void> _createTables() async {
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS stores(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL)',
    );
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS user_data(id INTEGER PRIMARY KEY, name TEXT, email TEXT UNIQUE, password TEXT)',
    );
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS user_favorites(user_email TEXT, store_id INTEGER, PRIMARY KEY(user_email, store_id))',
    );
  }

  // Fetch stores from the database
  Future<void> fetchStores() async {
    final List<Map<String, dynamic>> storeMaps = await _db.query('stores');
    _stores = List.generate(storeMaps.length, (index) {
      return Store(
        id: storeMaps[index]['id'],
        name: storeMaps[index]['name'],
        latitude: storeMaps[index]['latitude'],
        longitude: storeMaps[index]['longitude'],
      );
    });
    notifyListeners();
  }

  // Method to add a store to favorites for the current user
  Future<void> addFavorite(String userEmail, int storeId) async {
    await _db.insert(
      'user_favorites',
      {'user_email': userEmail, 'store_id': storeId},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Update shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteStoreIds = prefs.getStringList(userEmail) ?? [];
    favoriteStoreIds.add(storeId.toString());
    prefs.setStringList(userEmail, favoriteStoreIds);

    notifyListeners();
  }

  // Method to retrieve favorites for a user
  Future<void> getFavorites(String userEmail) async {
    final List<Map<String, dynamic>> maps = await _db.query(
      'user_favorites',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );

    final List<int> storeIds =
        maps.map<int>((item) => item['store_id'] as int).toList();

    // Fetch stores based on store ids
    _favorites = _stores.where((store) => storeIds.contains(store.id)).toList();

    notifyListeners();
  }
}