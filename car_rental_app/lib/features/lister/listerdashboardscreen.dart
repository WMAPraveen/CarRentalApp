import 'package:flutter/material.dart';

class ListerDashboardScreen extends StatelessWidget {
  const ListerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lister Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome, Lister!'),
        
      ),
    );
  }
}
