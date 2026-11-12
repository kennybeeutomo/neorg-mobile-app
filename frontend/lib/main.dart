import 'package:flutter/material.dart';

import 'pages/startup_page.dart';

void main() {
  runApp(const NeorgMobileApp());
}

class NeorgMobileApp extends StatelessWidget {
  const NeorgMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neorg Mobile',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),

      home: const StartupPage(),
    );
  }
}
