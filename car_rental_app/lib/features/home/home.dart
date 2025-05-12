import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:car_rental_app/features/vehicledetails/shope.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  late Timer _scrollTimer;
  double _scrollPosition = 0;
  late double _cardWidth;
  final double _cardSpacing = 12;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cardWidth = MediaQuery.of(context).size.width - 32;

      _scrollTimer = Timer.periodic(const Duration(seconds: 6), (_) {
        final maxScroll = _scrollController.position.maxScrollExtent;

        if (_scrollPosition + _cardWidth + _cardSpacing > maxScroll) {
          _scrollPosition = 0;
        } else {
          _scrollPosition += _cardWidth + _cardSpacing;
        }

        _scrollController.animateTo(
          _scrollPosition,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _scrollTimer.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      return userDoc.data()?['name'] ?? 'User';
    }
    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    _cardWidth = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      FutureBuilder<String>(
                        future: _getUserName(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text(
                              'Hello...',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                          final userName = snapshot.data ?? 'User';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello $userName,',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Good Morning',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for cars, locations...',
                        hintStyle: TextStyle(color: Colors.grey),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        suffixIcon: Icon(Icons.mic, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'RECOMMENDED LOCATIONS',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                height: 280,
                child: ListView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFixedSizeCard( 'assets/images/I1.png'),
                    SizedBox(width: _cardSpacing),
                    _buildFixedSizeCard( 'assets/images/I2.png'),
                    SizedBox(width: _cardSpacing),
                    _buildFixedSizeCard( 'assets/images/I3.png'),
                    SizedBox(width: _cardSpacing),
                    _buildFixedSizeCard( 'assets/images/I4.png'),
                  
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'MOST RENTED VEHICLES',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  _buildVehicleCard('Wijesinghe Rent Cars', 'Matara'),
                  const SizedBox(height: 8),
                  _buildVehicleCard('Weerakkodi Car Rentals', 'Rathnapura'),
                  const SizedBox(height: 8),
                  _buildVehicleCard('Wijesundara Rent Service', 'Anuradhapura'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFixedSizeCard( String imagePath) {
    return SizedBox(
      width: _cardWidth,
      height: 190,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      'Image failed to load',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              
            ),
            // Container(
            //   color: Colors.black.withOpacity(0.4),
            //   alignment: Alignment.center,
            //   child: Text(
            //     label,
            //     style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(String title, String location) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Shope(
              title: title,
              location: location,
            ),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Center(child: Text('Image Placeholder')),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(location, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
