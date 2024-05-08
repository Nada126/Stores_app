import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import '../../../providers/store_provider.dart';
import '../../../providers/position_provider.dart';
import '../../../blocs/distance_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

class FavoriteStoresScreen extends StatelessWidget {
  const FavoriteStoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final distanceBloc = Provider.of<DistanceBloc>(context);

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

    void requestPermission() async {
      if (await Permission.location.request().isGranted) {
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permission denied to access location.'),
          ),
        );
      }
    }

    void showDistance(double distance) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Distance'),
            content: Text('The distance to the store is $distance km.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }

    if (currentPosition != null) {
      double distanceInMeters = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        store.latitude,
        store.longitude,
      );

      double distanceInKm = distanceInMeters / 1000;
      showDistance(distanceInKm);
    } else {
      requestPermission();
    }
  }
}
