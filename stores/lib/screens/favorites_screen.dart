import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import '../../../providers/store_provider.dart';
import '../../../providers/position_provider.dart'; // Import the PositionProvider
import '../../../blocs/distance_bloc.dart'; // Import your DistanceBloc

class FavoriteStoresScreen extends StatelessWidget {
  const FavoriteStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final distanceBloc =
        Provider.of<DistanceBloc>(context); // Provide your DistanceBloc

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Stores'),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          List<Store> favoriteStores = storeProvider.favorites;

          return ListView.builder(
            itemCount: favoriteStores.length,
            itemBuilder: (context, index) {
              Store store = favoriteStores[index];
              return ListTile(
                title: Text(store.name),
                subtitle: Text(
                    'Latitude: ${store.latitude}, Longitude: ${store.longitude}'),
                trailing: ElevatedButton(
                  onPressed: () =>
                      _calculateDistance(context, store, distanceBloc),
                  child: const Text('Calculate Distance'),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _calculateDistance(
      BuildContext context, Store store, DistanceBloc distanceBloc) {
    PositionProvider positionProvider =
        Provider.of<PositionProvider>(context, listen: false);
    Position? currentPosition = positionProvider.currentPosition;

    if (currentPosition != null) {
      distanceBloc.calculateDistance(currentPosition, store);
    } else {
      Geolocator.getLastKnownPosition().then((position) {
        if (position != null) {
          positionProvider.updatePosition(position);
          distanceBloc.calculateDistance(position, store);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not determine current position.'),
            ),
          );
        }
      }).catchError((e) {
        print(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error getting location: $e'),
          ),
        );
      });
    }
  }
}
