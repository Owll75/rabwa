import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rabwa/features/commonFeature/data/doctor_repository.dart';
import 'package:rabwa/features/commonFeature/data/user_repository.dart';
import 'package:rabwa/features/commonFeature/domain/doctor.dart';
import 'package:rabwa/features/commonFeature/domain/user.dart';
import 'package:rabwa/features/firebase_auth/firebase_auth_services.dart';
import 'package:rabwa/features/firebase_auth/presentation/login_page.dart';
import 'package:rabwa/features/firebase_auth/presentation/widgets/formContinter.dart';
import 'package:rabwa/main.dart';
import 'dart:math';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool isSigningUp = false;
  bool isDoctor = false; // New variable to track if user is a doctor

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("SignUp"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              FormContainerWidget(
                controller: _usernameController,
                hintText: "Username",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Checkbox(
                    value: isDoctor,
                    onChanged: (bool? value) {
                      setState(() {
                        isDoctor = value ?? false;
                      });
                    },
                  ),
                  Text("Are you a doctor?")
                ],
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: () {
                  _signUp();
                },
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                      child: isSigningUp
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                            (route) => false);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    setState(() {
      isSigningUp = true;
    });

    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      if (isDoctor) {
        Doctor doctor = Doctor(docId: user!.uid, name: username);
        DoctorDatasource doctorDatasource = DoctorDatasource();
        doctorDatasource.createDoctor(doctor);
      } else {
        UserData newuser = UserData(
            docId: user!.uid,
            email: email,
            id: generateRandomNumberString(),
            name: username,
            phone: "");
        UsersDatasource usersDatasource = UsersDatasource();
        usersDatasource.createUser(newuser);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavigationBarDemo()),
      );
    }
    setState(() {
      isSigningUp = false;
    });
  }

  //function that will generate and return a string of 5 random numbers to be used as ID
  String generateRandomNumberString() {
    Random random = Random();
    String numberString = '';

    for (int i = 0; i < 5; i++) {
      numberString += random.nextInt(10).toString(); // Random digit from 0 to 9
    }

    return numberString;
  }
}
