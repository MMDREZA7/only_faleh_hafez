import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.green[800],
          ),
          const SizedBox(height: 25),
          const Text(
            'لطفا کمی صبر کنید',
            style: TextStyle(
              fontFamily: 'iranSans',
              fontWeight: FontWeight.w300,
              fontSize: 22,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
