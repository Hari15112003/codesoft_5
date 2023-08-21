import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:university_management/calander_screen.dart/home_page.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CourseList());
  }
}

class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('courses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        List<CourseTile> courseTiles = [];
        for (var doc in snapshot.data!.docs) {
          var data = doc.data() as Map<String, dynamic>;
          String courseId = doc.id;
          String courseName = data['name'];
          String courseDescription = data['description'];
          int enrollmentCount = data['enrollment'] ?? 0;
          List<String> enrolledStudents =
              List.from(data['enrolled_students'] ?? []);
          DateTime? enrollmentDate;
          if (enrolledStudents.contains(user!.uid)) {
            enrollmentDate = data['enrollment_dates'][user.uid].toDate();
          }

          courseTiles.add(
            CourseTile(
              courseId: courseId,
              courseName: courseName,
              courseDescription: courseDescription,
              enrollmentCount: enrollmentCount,
              enrollmentDate: enrollmentDate,
              isEnrolled: enrolledStudents.contains(user.uid),
              enrolledStudents: const [],
            ),
          );
        }

        return SizedBox(
          height: 700,
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                children: courseTiles,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text('child'))
            ],
          ),
        );
      },
    );
  }
}

class CourseTile extends StatefulWidget {
  final String courseId;
  final String courseName;
  final String courseDescription;
  final int enrollmentCount;

  final bool isEnrolled;
  final DateTime? enrollmentDate;
  final List<String> enrolledStudents;
  const CourseTile({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseDescription,
    required this.enrollmentCount,
    required this.isEnrolled,
    required this.enrollmentDate,
    required this.enrolledStudents,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CourseTileState createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {
  void _toggleEnrollment() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (widget.isEnrolled) {
        _unenrollFromCourse(user.uid);
      } else {
        _enrollInCourse(user.uid);
      }
    }
  }

  void _enrollInCourse(String userid) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .update({
      'enrollment': widget.enrollmentCount + 1,
      'enrolled_students': FieldValue.arrayUnion([userid]),
      'enrollment_dates.${userid}': DateTime.now()
      // FieldValue.serverTimestamp(),
    });
  }

  void _unenrollFromCourse(String userid) async {
    await FirebaseFirestore.instance
        .collection('courses')
        .doc(widget.courseId)
        .update({
      'enrollment_count': widget.enrollmentCount - 1,
      'enrolled_students': FieldValue.arrayRemove([userid]),
      'enrollment_dates.${userid}': FieldValue.delete(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.courseName),
      subtitle: Text(widget.courseDescription),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Text('Enrollment: ${widget.enrollmentCount}')),
          if (widget.enrollmentDate != null)
            Text('Enrolled on: ${widget.enrollmentDate!.toString()}'),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _toggleEnrollment();
                print(widget.isEnrolled);
              },
              child: Text(widget.isEnrolled ? 'Unenroll' : 'Enroll'),
            ),
          ),
        ],
      ),
    );
  }
}
