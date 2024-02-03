import 'package:alive_service_app/features/auth/screens/login_page.dart';
import 'package:alive_service_app/features/drawer/screens/main_page.dart';
import 'package:alive_service_app/features/workers/screens/location_search.dart';
import 'package:alive_service_app/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: AliveApp()));
}

class AliveApp extends ConsumerWidget {
  const AliveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Alive_App',
      home: const MainPage(),
      onGenerateRoute: (settings)=>generateRoute(settings),
    );
  }
}




