import "config.dart";
import 'package:flutter/material.dart';

void main() {
  print("test: ${DSGTConfig.test["test123"].toString()}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Hacklytics 2023",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hacklytics 2023"),
      ),
      body: const Center(
        child: Text("Hello World"),
      ),
    );
  }
}
