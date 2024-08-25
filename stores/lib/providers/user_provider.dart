import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String email;
  final String name;

  User({required this.email, required this.name});
}

class UserProvider extends ChangeNotifier {
  late User _currentUser;

  User get currentUser => _currentUser;

  // Initialize the user provider and load user data from local storage
  UserProvider() {
    _loadCurrentUser();
  }

  // Load user data from local storage (for example, SharedPreferences)
  Future<void> _loadCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userEmail = prefs.getString('user_email') ?? '';
    String userName = prefs.getString('user_name') ?? '';

    _currentUser = User(email: userEmail, name: userName);
    notifyListeners();
  }

  // Update the current user with new data
  void updateUser(String email, String name) {
    _currentUser = User(email: email, name: name);
    // Save user data to local storage
    _saveCurrentUser();
    notifyListeners();
  }

  // Save user data to local storage
  Future<void> _saveCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', _currentUser.email);
    await prefs.setString('user_name', _currentUser.name);
  }
}