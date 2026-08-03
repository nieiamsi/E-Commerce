import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Catalog')),
      body: const Center(
        child: Text('Login Successful! Catalog loading on Day 2.'),
      ),
    );
  }
}
