import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker_android/image_picker_android.dart';
import 'package:image_picker_platform_interface/image_picker_platform_interface.dart';
import 'providers/AuthProvider.dart';
import 'providers/ShopProvider.dart';
import 'screens/splash/SplashScreen.dart';
import 'screens/auth/LoginScreen.dart';
import 'screens/auth/SignUpScreen.dart';
import 'screens/home/HomeScreen.dart';
import 'screens/home/ProductDetailScreen.dart';
import 'screens/cart/AddToCartScreen.dart';
import 'screens/cart/CheckoutScreen.dart';
import 'screens/orders/HistoryScreen.dart';
import 'screens/profile/ProfileScreen.dart';
import 'screens/profile/EditProfileScreen.dart';
import 'screens/favorite/FavoriteScreen.dart';

import 'providers/ThemeProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Shopaholic',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColor: const Color(0xFF667EEA),
              scaffoldBackgroundColor: const Color(0xFFF8F9FA),
              useMaterial3: true,
              fontFamily: 'Outfit',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF667EEA),
                brightness: Brightness.light,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: const Color(0xFF667EEA),
              scaffoldBackgroundColor: const Color(0xFF050A14),
              useMaterial3: true,
              fontFamily: 'Outfit',
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF667EEA),
                brightness: Brightness.dark,
              ),
            ),
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignUpScreen(),
              '/home': (context) => const HomeScreen(),
              '/product-detail': (context) => const ProductDetailScreen(),
              '/cart': (context) => const AddToCartScreen(),
              '/checkout': (context) => const CheckoutScreen(),
              '/orders': (context) => const HistoryScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/edit-profile': (context) => const EditProfileScreen(),
              '/favorites': (context) => const FavoriteScreen(),
            },
          );
        },
      ),
    );
  }
}
