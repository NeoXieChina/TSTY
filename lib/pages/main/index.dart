import 'package:flutter/material.dart';
import 'package:tsty_app/style/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TSTY App',
      theme: AppTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(title: const Text('Main Page')),
        body: const Center(child: Text('Welcome to the Main Page!')),
      ),
    );
  }
}
