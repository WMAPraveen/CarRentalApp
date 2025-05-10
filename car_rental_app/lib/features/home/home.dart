import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Function to fetch the user's name from Firestore
  Future<String> _getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      return userDoc.data()?['name'] ?? 'User'; // Fallback to 'User' if name is not found
    }
    return 'User'; // Fallback if no user is logged in
  }

  @override
  Widget build(BuildContext context) {
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
            // Header Section
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
                        backgroundColor: Colors.grey, // Placeholder for profile image
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
                          if (snapshot.hasError) {
                            return const Text(
                              'Hello User,',
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
            // Category Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryTab('All', isSelected: true),
                  _buildCategoryTab('Car'),
                  _buildCategoryTab('Bike'),
                  _buildCategoryTab('Van'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Recommended Locations
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'RECOMMENDED LOCATIONS',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(child: _buildLocationCard('Danusha rent cars', '5.0', 'Car Rental Agency', 'Homagama', 'Open 24 hours', '077 123 4567')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildLocationCard('VS rent cars', '5.0', 'Car Rental Agency', '', 'Open 24 hours', '077 123 4567')),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Most Rented Vehicles
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: const Text(
                'MOST RENTED VEHICLES',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildVehicleCard(
                'Honda Civic',
                'Automatic/Manual',
                'Homagama',
                'Rs 6,000 / DAY',
                isBooked: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTab(String title, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildLocationCard(String title, String rating, String category, String location, String hours, String phone) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  rating,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.star, color: Colors.yellow, size: 16),
                const Icon(Icons.star, color: Colors.yellow, size: 16),
                const Icon(Icons.star, color: Colors.yellow, size: 16),
                const Icon(Icons.star, color: Colors.yellow, size: 16),
                const Icon(Icons.star, color: Colors.yellow, size: 16),
              ],
            ),
            const SizedBox(height: 4),
            Text(category, style: const TextStyle(color: Colors.grey)),
            if (location.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(location, style: const TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 4),
            Text(hours, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(phone, style: const TextStyle(color: Colors.grey)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.directions, color: Colors.blue),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleCard(String title, String transmission, String location, String price, {bool isBooked = false}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 60,
              color: Colors.grey[300], // Placeholder for vehicle image
              child: const Center(child: Text('Image Placeholder')),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      if (isBooked)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Booked',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(transmission, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(location, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    price,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}