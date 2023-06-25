import 'package:assignment/verify_otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

class Get_Otp extends StatefulWidget {
  const Get_Otp({Key? key}) : super(key: key);

  @override
  _Get_OtpState createState() => _Get_OtpState();
}

class _Get_OtpState extends State<Get_Otp> {
  late FocusNode _mobileNumberFocusNode;
  bool _isMobileNumberComplete = false;
  TextEditingController _countryCodeController =
      TextEditingController(text: '+91');
  TextEditingController _mobileNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mobileNumberFocusNode = FocusNode();
    // Open keyboard instantly when the page loads
    _openKeyboard();
  }

  @override
  void dispose() {
    _mobileNumberFocusNode.dispose();
    _countryCodeController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  void _openKeyboard() {
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_mobileNumberFocusNode);
    });
  }

  void _updateMobileNumber(String value) {
    setState(() {
      _isMobileNumberComplete = value.length == 10;
    });
  }

  void _continueButtonPressed() async {
    if (_isMobileNumberComplete) {
      String phoneNumber = _countryCodeController.text.trim() +
          _mobileNumberController.text.trim();
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential authCredential) async {
          await FirebaseAuth.instance.signInWithCredential(authCredential);
          // TODO: Handle successful verification
        },
        verificationFailed: (FirebaseAuthException authException) {
          print(authException.message);
          // TODO: Handle verification failure
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Verify_Otp(verificationId: verificationId),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(verificationId);
          print("Timeout");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/Vector7.png', // Replace with your image path
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
                    const SizedBox(height: 16),
                    Text(
                      'Please enter your mobile number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'You will receive a 6-digit code',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'to verify next',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 310, // Set the desired width
                      child: Row(
                        children: [
                          Container(
                            width:
                                80, // Set the width of the country code field
                            child: TextFormField(
                              controller: _countryCodeController,
                              decoration: InputDecoration(
                                labelText: 'Code',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _mobileNumberController,
                              focusNode: _mobileNumberFocusNode,
                              decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                border: OutlineInputBorder(),
                                errorText: _isMobileNumberComplete
                                    ? null
                                    : 'Please enter a valid mobile number',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              keyboardType: TextInputType.phone,
                              onChanged: _updateMobileNumber,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 310, // Set the desired width
                      height: 48, // Set the desired height
                      child: ElevatedButton(
                        onPressed: _isMobileNumberComplete
                            ? _continueButtonPressed
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xFF2E3B62), // Set the button background color
                        ),
                        child: const Text('CONTINUE'),
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
                'assets/Vector8.png', // Replace with your overlay image path
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

