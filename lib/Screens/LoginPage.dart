import 'package:esantren_insights_v1/Services/Authentication.dart';
import 'package:esantren_insights_v1/Screens/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-page';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  String errorMessage = '';
  bool isLogin = true;

  Future<void> signInWithEmailAndPassword() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Signing in...")
            ],
          ),
        );
      },
    );
    try {
      await Auth().signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
      print('Sign in successful');
    } on FirebaseAuthException catch (e) {
      setState(() {
        // errorMessage = e.message;
        print(e);
        errorMessage = 'Email atau password salah. Silakan coba lagi.';

        // Show a snackbar if authentication fails
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   duration: Duration(milliseconds: 2000),
        //   backgroundColor: Colors.red,
        //   content: Text(
        //     'Incorrect email or password. Please try again.',
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ));
      });
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0)),
                          child: Container(
                            constraints: BoxConstraints(maxWidth: 800),
                            padding: EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Image.asset(
                                  'assets/transparency.png', // replace this with your image asset path
                                  height: 200, // adjust the height as needed
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 16.0),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: Text(errorMessage,
                                      style: GoogleFonts.poppins(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400)),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32.0),
                        ElevatedButton(
                          onPressed: () {
                            signInWithEmailAndPassword();

                            // if (_formKey.currentState!.validate()) {
                            //   // TODO: Perform login with email and password
                            // }
                          },
                          child: Text(
                            'Login',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        RichText(
                          text: TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Register',
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
