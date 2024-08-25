import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stores/providers/store_provider.dart';
import 'package:stores/providers/user_provider.dart';
import 'package:stores/screens/favorites_screen.dart';
import 'notifiers/favorite_store_notifier.dart';
import 'screens/signup.dart';
import 'screens/home_screen.dart';
import 'screens/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoreProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteStoreNotifier()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const Login(),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/sign_up': (context) => const SignupPage(),
          '/favorites': (context) => const FavoritesScreen (),
        },
      ),
    );
  }
}