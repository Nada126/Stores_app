import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../models/store.dart';

class DistanceBloc {
  final _distanceController = StreamController<double>();
  Stream<double> get distanceStream => _distanceController.stream;

  void calculateDistance(Position currentPosition, Store store) {
    double distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      store.latitude,
      store.longitude,
    );

    double distanceInKm = distanceInMeters / 1000;
    _distanceController.sink.add(distanceInKm);
  }

  void dispose() {
    _distanceController.close();
  }
}