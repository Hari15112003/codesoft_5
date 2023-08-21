import 'package:flutter/material.dart';
import 'package:university_management/authentication/signin_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // ignore: prefer_final_fields
  List<bool> _isselected = [true, false];
  @override
  Widget build(BuildContext context) {
    //callinf provider
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/image1.png",
              height: height * 0.38,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Let's get started",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: height * 0.026,
            ),
            const Text(
              "Never a better time than now to start ",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black38,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ToggleButtons(
              isSelected: _isselected,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < _isselected.length; i++) {
                    _isselected[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: const Color.fromARGB(255, 198, 47, 240),
              selectedColor: Colors.white,
              fillColor: const Color.fromARGB(255, 213, 154, 239),
              color: const Color.fromARGB(255, 178, 80, 239),
              constraints: const BoxConstraints(
                minHeight: 30.0,
                minWidth: 80.0,
              ),
              children: const [Text('Instructor'), Text('Student')],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  child: const Text('GetStarted'),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthScreen(
                                  usertype:
                                      _isselected[0] ? 'Instructor' : 'student',
                                )));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
