import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PositionProvider with ChangeNotifier {
  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  void updatePosition(Position newPosition) {
    _currentPosition = newPosition;
    notifyListeners();
  }
}