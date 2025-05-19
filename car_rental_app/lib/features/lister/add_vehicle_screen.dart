import 'dart:io';
import 'dart:typed_data';
import 'package:car_rental_app/models/vehicle.dart';
import 'package:car_rental_app/services/vehicle_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'
    if (dart.library.html) 'dart:html'
    as html; // Conditionally import for File

class AddVehicleScreen extends StatefulWidget {
  @override
  _AddVehicleScreenState createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedType;

  Uint8List? _webImage; // For web
  XFile? _pickedImage; // For all
  final _picker = ImagePicker();

  final List<String> _vehicleTypes = ['Car', 'Van', 'SUV', 'Bike', 'Truck'];

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _pickedImage = image;
        });

        if (kIsWeb) {
          final bytes = await image.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
    }
  }

  void _confirmSubmission() {
    if (_formKey.currentState!.validate()) {
      if (_pickedImage == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select an image')));
        return;
      }

      if (_selectedType == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Please select a vehicle type')));
        return;
      }

      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text('Confirm', style: TextStyle(color: Colors.white)),
              content: Text(
                'Do you want to add this vehicle?',
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _submitForm();
                  },
                  child: Text('Yes', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields')),
      );
    }
  }

  void _submitForm() async {
    final newVehicle = Vehicle(
      id: DateTime.now().toString(),
      name: _nameController.text,
      type: _selectedType!,
      pricePerDay: double.parse(_priceController.text),
      imagePath: _pickedImage!.path, // You can change logic here for Web saving
      description: _descriptionController.text,
    );

    List<Vehicle> currentList = await VehicleStorage.loadVehicles();
    currentList.add(newVehicle);
    await VehicleStorage.saveVehicles(currentList);

    Navigator.pop(context, newVehicle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Add Your Vehicle"),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: "Vehicle Name",
                  validator:
                      (value) =>
                          value!.isEmpty ? "Please enter a vehicle name" : null,
                ),
                SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: _inputDecoration("Vehicle Type"),
                  dropdownColor: Colors.grey[850],
                  style: TextStyle(color: Colors.white),
                  items:
                      _vehicleTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value),
                  validator:
                      (value) =>
                          value == null ? 'Please select a vehicle type' : null,
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _priceController,
                  label: "Price Per Day",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter a price';
                    final price = double.tryParse(value);
                    if (price == null || price <= 0)
                      return 'Enter a valid number';
                    return null;
                  },
                ),
                SizedBox(height: 12),
                _buildTextField(
                  controller: _descriptionController,
                  label: "Description (Optional)",
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () => _showImageSourceDialog(),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[700]!, width: 1),
                    ),
                    child:
                        _pickedImage != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child:
                                  kIsWeb
                                      ? Image.memory(
                                        _webImage!,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.file(
                                        File(_pickedImage!.path),
                                        fit: BoxFit.cover,
                                      ),
                            )
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 64,
                                  color: Colors.white38,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Tap to add vehicle image",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: Icon(Icons.camera_alt, color: Colors.white70),
                      label: Text(
                        "Camera",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: Icon(Icons.photo_library, color: Colors.white70),
                      label: Text(
                        "Gallery",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _confirmSubmission,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                    ),
                    child: Text("Add Vehicle"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Select Image', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.white70),
                  title: Text('Camera', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.white70),
                  title: Text('Gallery', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
      decoration: _inputDecoration(label),
      validator: validator,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
