import 'package:flutter/material.dart';
import './signin.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Placeholder for the car image (blank area)
            Expanded(
              flex: 2,
              child: Container(
                color: Colors.black, // Matches background to simulate image space
              ),
            ),
            // Content section without scroll, with adjusted layout
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16.0), // Reduced padding from 24 to 16
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Premium Vehicle Rentals',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24, // Reduced from 28 to 24
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12), // Reduced from 16 to 12
                    const Text(
                      'agavsbdxjusu hbachbh bchbc cbahgyg\njdcj nqja njsxnjnc', // Placeholder text
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12, // Reduced from 14 to 12
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20), // Reduced from 32 to 20
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        padding: const EdgeInsets.symmetric(
                          vertical: 12, // Reduced from 16 to 12
                          horizontal: 40,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Let\'s Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}