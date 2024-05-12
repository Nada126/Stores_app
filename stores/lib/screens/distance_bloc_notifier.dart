import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import '../../../providers/position_provider.dart';
import '../../../blocs/distance_bloc.dart';

// Wrapper class around DistanceBloc to make it conform to ChangeNotifier
class DistanceBlocNotifier extends ChangeNotifier {
  final DistanceBloc distanceBloc = DistanceBloc();
}

class DistanceScreen extends StatelessWidget {
  final Store store;

  const DistanceScreen({Key? key, required this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PositionProvider>(create: (_) => PositionProvider()),
        ChangeNotifierProvider<DistanceBlocNotifier>(create: (_) => DistanceBlocNotifier()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Favorite Stores'),
        ),
        body: Consumer<PositionProvider>(
          builder: (context, positionProvider, child) {
            final currentPosition = positionProvider.currentPosition;

            if (currentPosition != null) {
              return _buildDistanceWidget(context, currentPosition);
            } else {
              return _buildPermissionWidget(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildDistanceWidget(BuildContext context, Position currentPosition) {
    final distanceBloc = Provider.of<DistanceBlocNotifier>(context).distanceBloc;

    final distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      store.latitude,
      store.longitude,
    );

    final distanceInKm = distanceInMeters / 1000;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Distance to ${store.name}:',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Text(
            '${distanceInKm.toStringAsFixed(2)} km',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Location permission not granted.',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _requestPermission(context),
            child: Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _requestPermission(BuildContext context) async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      Provider.of<PositionProvider>(context, listen: false).updatePosition(await Geolocator.getCurrentPosition());
    }
  }
}
