import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _profileImage;
  File? _coverImage;
  final picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController(
    text: 'User Name',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'user@example.com',
  );
  final TextEditingController _locationController = TextEditingController(
    text: 'Colombo, Sri Lanka',
  );
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController(
    text: 'This is a short bio.',
  );

  Future<void> _pickImage(bool isProfile) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(pickedFile.path);
        } else {
          _coverImage = File(pickedFile.path);
        }
      });
    }
  }

  void _saveChanges() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profile updated')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
                      image:
                          _coverImage != null
                              ? DecorationImage(
                                image: FileImage(_coverImage!),
                                fit: BoxFit.cover,
                              )
                              : null,
                    ),
                    child:
                        _coverImage == null
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
                      backgroundImage:
                          _profileImage != null
                              ? FileImage(_profileImage!)
                              : AssetImage('assets/profile.jpg')
                                  as ImageProvider,
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
