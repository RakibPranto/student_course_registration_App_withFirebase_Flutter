import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddNewCourse extends StatefulWidget {
  const AddNewCourse({Key? key}) : super(key: key);

  @override
  State<AddNewCourse> createState() => _AddNewCourseState();
}

class _AddNewCourseState extends State<AddNewCourse> {
  final TextEditingController _coursenameController = TextEditingController();
  final TextEditingController _coursefeeController = TextEditingController();
  XFile? _courseImage;
  chosseImageFromGC() async {
    ImagePicker picker = ImagePicker();
    _courseImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});               
  }

  String? imageUrl;
  writeData() async {
    File imageFile = File(_courseImage!.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask uploadTask =
        storage.ref('course').child(_courseImage!.name).putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    imageUrl = await snapshot.ref.getDownloadURL();
    CollectionReference coursedata =
        FirebaseFirestore.instance.collection("course");
    coursedata.add({
      'course_name': _coursenameController.text,
      'course_fee': _coursefeeController.text,
      'img': imageUrl,
    });
  }

  @override
  void dispose() {
    _coursenameController.dispose();
    _coursefeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
          color: Colors.tealAccent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            TextField(
              controller: _coursenameController,
              decoration: InputDecoration(
                  hintText: "Enter Course Name..",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _coursefeeController,
              decoration: InputDecoration(
                  hintText: "Enter Course Fee..",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: _courseImage == null
                    ? IconButton(
                        onPressed: () {
                          chosseImageFromGC();
                        },
                        icon: const Icon(Icons.photo),
                      )
                    : Image.file(File(_courseImage!.path))),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  writeData();
                  Navigator.of(context).pop();
                },
                child: const Text("Add Data")),
          ],
        ),
      ),
    );
  }
}
