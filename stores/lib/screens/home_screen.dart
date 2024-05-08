import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import '../../../providers/store_provider.dart';
import 'add_favorites_screen.dart'; 
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
                  // Handle tap on the store tile if needed
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
        MaterialPageRoute(builder: (context) => const AddToFavoritesScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  const FavoriteStoresScreen()),
      );
    }
  }
}
