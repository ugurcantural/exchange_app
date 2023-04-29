import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [ SystemUiOverlay.top ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Döviz Kurları',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light,
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          shadowColor: Colors.white,
          surfaceTintColor: Colors.black,
        ),
      ),
      home: const HomePage(),
    );
  }
}