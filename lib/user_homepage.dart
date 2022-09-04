import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_course_management/adminsignIn.dart';
import 'package:student_course_management/courseEnroll.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({Key? key}) : super(key: key);

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final Stream<QuerySnapshot> _madStream = FirebaseFirestore.instance
      .collection('course')
      .orderBy('course_name')
      .snapshots();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Robo Tech Valley",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const AdminSignIn(),
                ));
              },
              icon: const Icon(
                Icons.admin_panel_settings,
                color: Colors.black,
              ))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _madStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              const Center(child: Text('error'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(blurRadius: 2, color: Colors.black)
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: SingleChildScrollView(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${data['course_name']}",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Course Fee: ${data['course_fee']} BDT",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 12),
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) =>
                                              CourseEnrollPage(
                                                  courseName:
                                                      data['course_name'],
                                                  courseFee:
                                                      data['course_fee']),
                                        ));
                                      },
                                      child: const Text("Enroll")),
                                ],
                              ),
                            ),
                            Container(
                              height: 200,
                              width: MediaQuery.of(context).size.width / 2.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        data['img'],
                                      ),
                                      fit: BoxFit.fill)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
