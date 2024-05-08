// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import '../providers/store_provider.dart';
// import '../models/store.dart';

// class DistanceScreen extends StatelessWidget {
//   const DistanceScreen({Key? key}) : super(key: key);

//   // @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<StoreProvider, dynamic>(
//       builder: (context, state) {
//         final storeProvider = context.read<StoreProvider>();
//         final currentLocation = storeProvider.currentLocation;

//         return Scaffold(
//           appBar: AppBar(
//             title: const Text('Distance to Favorite Stores'),
//           ),
//           body: ListView.builder(
//             itemCount: storeProvider.favorites.length,
//             itemBuilder: (context, index) {
//               Store store = storeProvider.favorites[index];
//               double distance = storeProvider.calculateDistance(
//                 currentLocation.latitude,
//                 currentLocation.longitude,
//                 store.latitude,
//                 store.longitude,
//               );

//               return ListTile(
//                 title: Text(store.name),
//                 subtitle: Text('${distance.toStringAsFixed(2)} km away'),
//               );
//             },
//           ),
//         );
//       },
//       listener: (context, state) {},
//     );
//   }
// }
