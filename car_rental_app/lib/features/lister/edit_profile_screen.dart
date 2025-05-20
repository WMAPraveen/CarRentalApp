import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage; // For mobile
  File? _coverImage; // For mobile
  Uint8List? _webProfileImage; // For web
  Uint8List? _webCoverImage; // For web
  String? _profileImageBase64; // Base64 for profile image
  String? _coverImageBase64; // Base64 for cover image
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController(text: 'User Name');
  final TextEditingController _emailController = TextEditingController(text: 'user@example.com');
  final TextEditingController _locationController = TextEditingController(text: 'Colombo, Sri Lanka');
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController(text: 'This is a short bio.');

  Future<void> _pickImage(bool isProfile) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        var imageBytes = await pickedFile.readAsBytes();
        setState(() {
          if (isProfile) {
            _webProfileImage = imageBytes;
            _profileImageBase64 = base64Encode(imageBytes);
          } else {
            _webCoverImage = imageBytes;
            _coverImageBase64 = base64Encode(imageBytes);
          }
        });
      } else {
        setState(() {
          if (isProfile) {
            _profileImage = File(pickedFile.path);
            List<int> imageBytes = _profileImage!.readAsBytesSync();
            _profileImageBase64 = base64Encode(imageBytes);
          } else {
            _coverImage = File(pickedFile.path);
            List<int> imageBytes = _coverImage!.readAsBytesSync();
            _coverImageBase64 = base64Encode(imageBytes);
          }
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'location': _locationController.text.trim(),
          'bio': _bioController.text.trim(),
          'profilePicture': _profileImageBase64 ?? '',
          'coverPicture': _coverImageBase64 ?? '',
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No user is currently signed in.')),
        );
      }
    } catch (e) {
      print('Failed to update profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImageWidget = _profileImage != null
        ? FileImage(_profileImage!)
        : _webProfileImage != null
            ? MemoryImage(_webProfileImage!)
            : AssetImage('assets/profile.jpg') as ImageProvider;

    final ImageProvider<Object>? coverImageWidget = _coverImage != null
        ? FileImage(_coverImage!)
        : _webCoverImage != null
            ? MemoryImage(_webCoverImage!)
            : null;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                GestureDetector(
                  onTap: () => _pickImage(false),
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      image: coverImageWidget != null
                          ? DecorationImage(
                              image: coverImageWidget,
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: coverImageWidget == null
                        ? Center(
                            child: Icon(
                              Icons.camera_alt,
                              size: 40,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => _pickImage(true),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: profileImageWidget,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            _buildTextField('Name', _nameController),
            SizedBox(height: 12),
            _buildTextField('Email', _emailController),
            SizedBox(height: 12),
            _buildTextField('Location', _locationController),
            SizedBox(height: 12),
            _buildTextField('Password', _passwordController, obscure: true),
            SizedBox(height: 12),
            _buildTextField('Bio Description', _bioController, maxLines: 3),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveChanges,
              icon: Icon(Icons.save),
              label: Text('Save Changes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscure = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}