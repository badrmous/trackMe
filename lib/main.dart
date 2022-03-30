import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:location/firebase_operations.dart';
import 'package:location/home.view.dart';
import 'package:location/location.notifier.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocationNotifier()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations())
        ],
        builder: (context, _) => const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: HomeView(),
            ));
  }
}
