import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/authform.dart';
import './signup.dart';
import './forgetpassword.dart'; // Import the new ForgetPasswordScreen
import '../../home/home.dart';
import '../../admin/admin.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;
  bool _rememberMe = false;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        //   onPressed: () => Navigator.pop(context),
        // ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Sign In',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Hi! Welcome back, you\'ve been missed',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.pinkAccent,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  AuthForm(
                    isSignIn: true,
                    isLoading: _isLoading,
                    obscurePassword: true,
                    onTogglePasswordVisibility: () {},
                    onSubmit: (email, password) async {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final userCredential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        final userDoc = await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userCredential.user!.uid)
                            .get();
                        final isAdmin = userDoc.data()?['isAdmin'] ?? false;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => isAdmin
                                ? const AdminDashboardScreen()
                                : const HomeScreen(),
                          ),
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              e.message ?? 'Sign-in failed',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.grey[800],
                          ),
                        );
                      } finally {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: _isLoading
                                ? null
                                : (value) {
                                    setState(() {
                                      _rememberMe = value ?? false;
                                    });
                                  },
                            activeColor: const Color(0xFFE74D3D),
                            checkColor: Colors.white,
                          ),
                          const Text(
                            'Remember me',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgetPasswordScreen(),
                                  ),
                                );
                              },
                        child: const Text(
                          'Forgot password...',
                          style: TextStyle(color: Color(0xFFE74D3D)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _onSubmit(
                                _emailController.text.trim(),
                                _passwordController.text,
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE74D3D),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFE74D3D),
                        ),
                        child: const Text('Sign up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit(String email, String password) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();
      final isAdmin = userDoc.data()?['isAdmin'] ?? false;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => isAdmin
              ? const AdminDashboardScreen()
              : const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ?? 'Sign-in failed',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey[800],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}