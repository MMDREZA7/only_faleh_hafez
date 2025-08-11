import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green[600],
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.green.shade900,
                width: 5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                  fit: BoxFit.cover,
                  width: 280,
                  image: const AssetImage(
                    "assets/images/main_logo_faal.png",
                  ),
                  color: Colors.green[900],
                ),
                const SizedBox(height: 50),
                const Text(
                  'فال حافظ',
                  style: TextStyle(
                    fontFamily: 'iranSans',
                    fontWeight: FontWeight.w300,
                    fontSize: 40,
                    color: Color(0xFF22221C),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
