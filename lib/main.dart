import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'get_otp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/next': (context) => const Get_Otp(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedLanguage = 'English'; // Default selected value
  bool _isLanguageSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Image.asset(
              'assets/Vector.png', // Replace with your image path
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100),
                    child: Image.asset(
                      'assets/image.png', // Replace with your logo image path
                      width: 100,
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Please select your language',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You can change the language',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'at any time',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the desired width
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedLanguage, // Set the selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                            _isLanguageSelected = true; // Update the selected value and validation flag
                          });
                        },
                        items: <String>['English', 'Hindi']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the desired width
                    child: ElevatedButton(
                      onPressed: _isLanguageSelected
                          ? () {
                              Navigator.pushNamed(context, '/next');
                            }
                          : null, // Disable the button if no language is selected
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3B62), // Set the button background color
                      ),
                      child: const Text('NEXT'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/Vector2.png', // Replace with your overlay image path
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
