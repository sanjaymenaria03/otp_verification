import 'package:assignment/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Verify_Otp extends StatefulWidget {
  final String verificationId;

  const Verify_Otp({Key? key, required this.verificationId}) : super(key: key);

  @override
  _Verify_OtpState createState() => _Verify_OtpState();
}

class _Verify_OtpState extends State<Verify_Otp> {
  late FocusNode _otpFocusNode;
  List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  late List<FocusNode> _otpFocusNodes;

  @override
  void initState() {
    super.initState();
    _otpFocusNode = FocusNode();
    _otpFocusNodes = List.generate(6, (_) => FocusNode());
    // Open keyboard when the page is loaded
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_otpFocusNode);
    });
  }

  @override
  void dispose() {
    _otpFocusNode.dispose();
    _otpControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _verifyAndContinue() {
    // Concatenate all OTP values
    String otp = _otpControllers.map((controller) => controller.text).join();

    // TODO: Implement the logic to verify the OTP

    // Example verification using the verificationId
    if (otp.isNotEmpty) {
      String verificationId = widget.verificationId;
      // TODO: Use the verificationId and otp to verify the OTP
      // You can use FirebaseAuth.instance.signInWithCredential() to verify the OTP
      // Once verified, you can proceed to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewScreen()),
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
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Verify Phone',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Code is sent to',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          6,
                          (index) => OtpBox(
                            focusNode: _otpFocusNodes[index],
                            controller: _otpControllers[index],
                            nextFocusNode: index != 5 ? _otpFocusNodes[index + 1] : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        // TODO: Add logic for requesting OTP again
                      },
                      child: Text(
                        "Request Again ?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 310, // Set the desired width
                      height: 48, // Set the desired height
                      child: ElevatedButton(
                        onPressed: _verifyAndContinue,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2E3B62),
                        ),
                        child: Text('VERIFY AND CONTINUE'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OtpBox extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController controller;
  final FocusNode? nextFocusNode;

  const OtpBox({
    this.focusNode,
    required this.controller,
    this.nextFocusNode,
  });

  @override
  _OtpBoxState createState() => _OtpBoxState();
}

class _OtpBoxState extends State<OtpBox> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (widget.controller.text.isNotEmpty) {
      widget.nextFocusNode?.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20),
        decoration: InputDecoration(
          counterText: '', // Hide character counter
          border: InputBorder.none, // Hide the default input field border
        ),
        onChanged: (_) {
          // Move focus to the next box when a digit is entered
          if (widget.controller.text.isNotEmpty) {
            widget.nextFocusNode?.requestFocus();
          }
        },
      ),
    );
  }
}


void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Verify_Otp(verificationId: ''), // Pass the verificationId from the previous screen
  ));
}
