import 'package:finger_print/secondscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class Fingerprint extends StatefulWidget {
  const Fingerprint({Key? key}) : super(key: key);

  @override
  State<Fingerprint> createState() => _FingerprintState();
}

class _FingerprintState extends State<Fingerprint> {
  LocalAuthentication auth = LocalAuthentication();
  late List<BiometricType> _availableBiometrics;
  String authorized = "Not authorized";

  @override
  void initState() {
    super.initState();
    _checkBiometric();
    _getAvailableBiometric();
    _authenticate(); // Automatically initiate fingerprint authentication when the screen is loaded
  }


  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      // Removed unused variable _canCheckBiometric
    });
  }

  Future<void> _getAvailableBiometric() async {
    List<BiometricType> availableBiometric = [];
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: "Scan your finger to authenticate",
      );
    } on PlatformException catch (e) {
      print("Authenticate Erroe: $e");
    }
    if (!mounted) return;
    setState(() {
      authorized = authenticated ? "Authorized success" : "Failed to Authenticate";
      if (authenticated) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => secondScreen()));
      }
      print(authorized);
    });
  }

  // @override
  // void initState() {
  //   _checkBiometric();
  //   _getAvailableBiometric();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Column(
                  children: [
                    Image.network(
                      "https://t4.ftcdn.net/jpg/02/94/11/39/360_F_294113931_zGUHqnDOTOdHyZC4ZQYbpF2zFsiOXAOM.jpg",
                      width: 120,
                    ),
                    Text("Fingerprint Auth"),
                    Text("Authenticate using your Fingerprint instead of your password"),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 15),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _authenticate,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    child: Text("Authenticate", style: TextStyle(color: Colors.white)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
