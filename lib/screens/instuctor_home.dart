import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class InstuctorHome extends StatefulWidget {
  const InstuctorHome({super.key});

  @override
  State<InstuctorHome> createState() => _InstuctorHomeState();
}

class _InstuctorHomeState extends State<InstuctorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddCoursePage()));
          },
          child: const Text('Add course'))
    ]));
  }
}

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _courseNameController = TextEditingController();
  final TextEditingController _courseDescriptionController =
      TextEditingController();
  final TextEditingController _courseFee = TextEditingController();
  final TextEditingController _courseInstructorName = TextEditingController();
  void _addCourse() {
    String courseName = _courseNameController.text;
    String courseDescription = _courseDescriptionController.text;
    String courseFee = _courseFee.text;
    String courseInstructorName = _courseInstructorName.text;

    // Add the course to Firestore
    _firestore.collection('courses').add({
      'name': courseName,
      'description': courseDescription,
      'instructor': courseFee,
      'courseInstructorName': courseInstructorName
    });

    // Clear text fields
    _courseNameController.clear();
    _courseDescriptionController.clear();
    _courseInstructorName.clear();
    _courseFee.clear();

    // Show a snackbar to confirm course addition
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Course added')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _courseNameController,
              decoration: const InputDecoration(labelText: 'Course Name'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _courseDescriptionController,
              decoration:
                  const InputDecoration(labelText: 'Course Description'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _courseFee,
              decoration: const InputDecoration(labelText: 'Course Fee'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _courseInstructorName,
              decoration:
                  const InputDecoration(labelText: 'Course Instructor Name'),
            ),
            ElevatedButton(
              onPressed: _addCourse,
              child: const Text('Add Course'),
            ),
          ],
        ),
      ),
    );
  }
}
