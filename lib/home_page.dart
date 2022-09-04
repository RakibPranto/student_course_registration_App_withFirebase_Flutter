import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_course_management/addnewcourse.dart';
import 'package:student_course_management/edit_a_course.dart';
import 'package:student_course_management/user_homepage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _addCourse() {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => const AddNewCourse());
  }

  _editCourse(document, CourseName, CourseFee, img) {
    showModalBottomSheet(
        isDismissible: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => EditACourse(
              document: document,
              CourseName: CourseName,
              CourseFee: CourseFee,
              img: img,
            ));
  }

  Future<void> _deleteCourse(selectDocument) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text("Are you sure?"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("cancel")),
                  TextButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('course')
                            .doc(selectDocument)
                            .delete()
                            .then((value) => print("Data has been deleted"));
                        Navigator.pop(context);
                      },
                      child: Text("ok")),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  final Stream<QuerySnapshot> _madStream = FirebaseFirestore.instance
      .collection('course')
      .orderBy('course_name')
      .snapshots();
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addCourse();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("All Course"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserHomePage(),
                    ));
              },
              icon: const Icon(Icons.logout))
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
                    child: Stack(
                      children: [
                        Container(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  width:
                                      MediaQuery.of(context).size.width / 2.2,
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
                        Positioned(
                            top: 2,
                            left: 16,
                            child: Card(
                              elevation: 8,
                              color: Colors.teal,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _editCourse(
                                            document.id,
                                            data["course_name"],
                                            data["course_fee"],
                                            data["img"]);
                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        _deleteCourse(document.id);
                                      },
                                      icon: Icon(Icons.delete)),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }),
    );
  }
}
