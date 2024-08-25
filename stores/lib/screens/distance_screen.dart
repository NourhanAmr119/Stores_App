import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../../../models/store.dart';
import '../../../providers/position_provider.dart';
import '../notifiers/distance_notifier.dart';

class DistanceScreen extends StatelessWidget {
  final Store store;

  const DistanceScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PositionProvider>(create: (_) => PositionProvider()),
        ChangeNotifierProvider<DistanceNotifier>(create: (_) => DistanceNotifier()), // Provide DistanceBloc
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
    final distanceBloc = Provider.of<DistanceNotifier>(context, listen: false);

    final distanceInMeters = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      store.latitude,
      store.longitude,
    );

    final distanceInKm = distanceInMeters / 1000;

    distanceBloc.calculateDistance(currentPosition, store); // Calculate distance

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Distance: $distanceInKm km',
            style: const TextStyle(fontSize: 20),
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
          const Text(
            'Location permission not granted.',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _requestPermission(context),
            child: const Text('Grant Permission'),
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
