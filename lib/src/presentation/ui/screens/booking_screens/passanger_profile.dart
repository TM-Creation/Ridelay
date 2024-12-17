import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ridely/src/presentation/ui/screens/booking_screens/ride_selection_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/base url.dart';
import '../../config/compress_image.dart';
import '../../config/theme.dart';

class PassangerProfile extends StatefulWidget {
  @override
  _PassangerProfileState createState() => _PassangerProfileState();
}

class _PassangerProfileState extends State<PassangerProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isReadOnly = true; // Controls the read-only state of the fields
  bool isLoading = false; // Controls the loading state during API calls
  String? token; // Holds the token for API calls

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // Load data from SharedPreferences
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('username') ?? '';
      emailController.text = prefs.getString('email') ?? '';
      phoneController.text = prefs.getString('phone') ?? '';
      token = prefs.getString('utoken');
    });
  }

  baseulr burl = baseulr();

  Future<void> _updateProfileData() async {
    final url = Uri.parse('${burl.burl}/api/v1/driver/profile'); // Replace with your API endpoint
    final body = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
    };

    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'authorization': 'Bearer $token',
    };

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      setState(() {
        isLoading = false;
      });
      print('Status Code ${response.body}');
      if (response.statusCode == 200) {
        // Update successful
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', nameController.text);
        await prefs.setString('email', nameController.text);
        await prefs.setString('phone', phoneController.text);
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
        setState(() {
          isReadOnly = true;
        });
        Navigator.of(context).pushReplacementNamed(
            VehicleSelectionScreen.routeName);
      } else {
        Get.snackbar(
          'Alert!',
          'Failed to update profile!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: themeColor,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
          duration: Duration(seconds: 3),
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar(
        'Error!',
        'Network Error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: themeColor,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Row(
            children: [
              Text(
                isReadOnly ? 'Edit' : 'Save',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              IconButton(
                icon: Icon(
                  isReadOnly ? Icons.edit : Icons.save,
                  color: Colors.white,
                ),
                onPressed: () {
                  if (isReadOnly) {
                    setState(() {
                      isReadOnly = false;
                    });
                  } else {
                    _updateProfileData();
                  }
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.width * 0.2,
            ),
            TextField(
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
              ),
              controller: nameController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                  color: themeColor,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeColor),
                ),
              ),
            ),
            SizedBox(height: size.width * 0.1),
            TextField(
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
              ),
              controller: emailController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: themeColor,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeColor),
                ),
              ),
            ),
            SizedBox(height: size.width * 0.1),
            TextField(
              style: TextStyle(
                color: themeColor,
                fontWeight: FontWeight.bold,
              ),
              controller: phoneController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(
                  color: themeColor,
                  fontSize: size.width * 0.05,
                  fontWeight: FontWeight.bold,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isLoading)
              Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
