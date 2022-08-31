import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_course_management/user_homepage.dart';

class CourseEnrollPage extends StatefulWidget {
  CourseEnrollPage({Key? key, this.courseName, this.courseFee})
      : super(key: key);
  String? courseName;
  String? courseFee;

  @override
  State<CourseEnrollPage> createState() => _CourseEnrollPageState();
}

class _CourseEnrollPageState extends State<CourseEnrollPage> {
  final TextEditingController _first_nameController = TextEditingController();
  final TextEditingController _last_nameController = TextEditingController();
  final TextEditingController _phone_noController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  CollectionReference enroller =
      FirebaseFirestore.instance.collection('enroller');
  Future<void> addUser() {
    return enroller.add({
      'first_name': _first_nameController.text,
      'last_name': _last_nameController.text,
      'age': _ageController.text,
      'occupation': _occupationController.text,
      'phone_no': _phone_noController.text,
      'address': _addressController.text,
      'course_name': widget.courseName,
      'course_fee': widget.courseFee,
    });
  }

  _buildBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserHomePage(),
                        ));
                  },
                  child: const Text('Ok'),
                )
              ],
              content: SizedBox(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      '${_first_nameController.text} your have Enrolled ${widget.courseName} Successfully......\nPlease pay ${widget.courseFee} BDT to Confirm your enrollment.......',
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
              )));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Registration",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _first_nameController,
                decoration: InputDecoration(
                    hintText: "First Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _last_nameController,
                decoration: InputDecoration(
                    hintText: "Last Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                    hintText: "Age",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _occupationController,
                decoration: InputDecoration(
                    hintText: "Occupation",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _phone_noController,
                decoration: InputDecoration(
                    hintText: "Phone No.",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                    hintText: "Address",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    addUser();
                    _buildBox();
                  },
                  child: const Text("Registration")),
            ],
          ),
        ),
      ),
    );
  }
}
