class Vehicle {
  final String id;
  final String name;
  final String type;
  final double pricePerDay;
  final String imagePath;
  bool isRented; // Indicates if the vehicle is rented
  bool isUnderMaintenance; // Indicates if the vehicle is under maintenance
  final String? description; // Optional description

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerDay,
    required this.imagePath,
    this.isRented = false,
    this.isUnderMaintenance = false,
    this.description,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      pricePerDay: json['pricePerDay'].toDouble(),
      imagePath: json['imagePath'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'pricePerDay': pricePerDay,
      'imagePath': imagePath,
      'description': description,
    };
  }
}
