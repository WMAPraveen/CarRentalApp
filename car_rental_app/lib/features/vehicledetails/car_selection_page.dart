
import 'package:car_rental_app/features/vehicledetails/book_now_page.dart';

import 'package:car_rental_app/models/car.dart';
import 'package:car_rental_app/widgets/car_card.dart';
import 'package:car_rental_app/widgets/category_filter_chip.dart';
import 'package:flutter/material.dart';

class CarSelectionPage extends StatefulWidget {
  const CarSelectionPage({Key? key}) : super(key: key);

  @override
  State<CarSelectionPage> createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage> {
  int selectedCarIndex = 0;
  
  final List<Car> availableCars = [
    Car(
      name: 'Toyota Camry',
      category: 'Sedan',
      pricePerDay: 59.99,
      features: ['Bluetooth', 'USB Charging', 'GPS Navigation'],
      imageUrl: 'assets/images/camry.jpg',
    ),
    Car(
      name: 'Honda CR-V',
      category: 'SUV',
      pricePerDay: 79.99,
      features: ['4x4', 'Spacious Boot', 'Panoramic Roof'],
      imageUrl: 'assets/images/crv.jpg',
    ),
    Car(
      name: 'Mercedes C-Class',
      category: 'Luxury',
      pricePerDay: 129.99,
      features: ['Leather Seats', 'Premium Sound', 'Heated Seats'],
      imageUrl: 'assets/images/mercedes.jpg',
    ),
    Car(
      name: 'Tesla Model 3',
      category: 'Electric',
      pricePerDay: 99.99,
      features: ['Autopilot', 'Zero Emissions', 'Fast Charging'],
      imageUrl: 'assets/images/tesla.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Your Car',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          // Top section with category filters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryFilterChip(label: 'All', isSelected: true),
                  CategoryFilterChip(label: 'Sedan', isSelected: false),
                  CategoryFilterChip(label: 'SUV', isSelected: false),
                  CategoryFilterChip(label: 'Luxury', isSelected: false),
                  CategoryFilterChip(label: 'Electric', isSelected: false),
                ],
              ),
            ),
          ),

          // Car list
          Expanded(
            child: ListView.builder(
              itemCount: availableCars.length,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return CarCard(
                  car: availableCars[index],
                  isSelected: selectedCarIndex == index,
                  onTap: () {
                    setState(() {
                      selectedCarIndex = index;
                    });
                  },
                );
              },
            ),
          ),

          // Continue button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookNowPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'CONTINUE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}