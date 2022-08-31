import 'package:flutter/material.dart';
import 'package:student_course_management/helper.dart';
import 'package:student_course_management/user_homepage.dart';

class AdminSignIn extends StatefulWidget {
  const AdminSignIn({Key? key}) : super(key: key);

  @override
  State<AdminSignIn> createState() => _AdminSignInState();
}

class _AdminSignInState extends State<AdminSignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const Icon(
          Icons.home,
          color: Colors.black,
          size: 40,
        ),
        backgroundColor: Colors.white,
        title: const Text('Admin',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              height: 50,
              width: double.infinity,
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: "Enter Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  hintText: "Enter Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  var obj = FirebaseHelpers().signIn(
                      _emailController.text, _passwordController.text, context);
                },
                child: const Text("Sign In")),
            TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserHomePage(),
                      ));
                },
                child: const Text("Not an Admin? Go Back.")),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "“Move fast, break things”",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                  fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
