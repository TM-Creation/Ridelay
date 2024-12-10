import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/base url.dart';
import '../../config/compress_image.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import 'driver_main_screen.dart';
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isReadOnly = true; // Controls the read-only state of the fields
  bool isLoading = false; // Controls the loading state during API calls
  File? profileImage;
  String? imageUrl,token; // Holds the uploaded image URL

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
      token =  prefs.getString('utoken');
      imageUrl = prefs.getString('profileImage');
    });
  }
  baseulr burl = baseulr();
  Future<void> uploadImage(PickedFile pickedFile) async {
    final String uploadUrl = '${burl.burl}/upload-image';
    try {
      // Convert PickedFile to File
      final File imageFile = File(pickedFile.path);
      var stream = http.ByteStream(imageFile.openRead().cast<List<int>>());

      var length = await imageFile.length();

      // Get the mime type of the file
      var mimeType = lookupMimeType(imageFile.path);

      // Create the multipart request
      var request = http.MultipartRequest('POST', Uri.parse(uploadUrl));

      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: path.basename(imageFile.path),
        contentType: MediaType(mimeType!.split('/')[0], mimeType.split('/')[1]),
      );

      // Attach the file to the request
      request.files.add(multipartFile);

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Get the response body
        final responseBody = await response.stream.bytesToString();
        print('Image uploaded successfully.');
        print('Response body: $responseBody');

        final jsonResponse = json.decode(responseBody);
        final imageUrl = jsonResponse['url'];

        setState(() {
          // Store the image URL or perform other actions
          profileImage = imageUrl; // Replace with your variable
          print('Image Uploaded, URL: $profileImage');
        });
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _updateProfileData() async {
    final url = Uri.parse('${burl
        .burl}/api/v1/driver/profile'); // Replace with your API endpoint
    final body = {
      'name': nameController.text,
      'email': emailController.text,
      'phone': phoneController.text,
      'driverImage': imageUrl, // Include the uploaded image URL
    };
    print('$body $token');
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      'authorization': 'Bearer $token'
    };

    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.put(url, headers: headers, body: jsonEncode(body));
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200) {
        // Update successful
        print('Profile updated successfully: ${response.body}');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', nameController.text);
        await prefs.setString('email', emailController.text);
        await prefs.setString('phone', phoneController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ));
        setState(() {
          isReadOnly = true;
        });
        Navigator.of(context).pushReplacementNamed(
            DriverRideSelectionScreen.routeName);
      } else {
        // Handle API error
        print('Failed to update profile: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to update profile!'),
          backgroundColor: Colors.red,
        ));
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Network error!'),
        backgroundColor: Colors.red,
      ));
    }
  }
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Future<bool> pickImage() async {
      try {
        // ignore: deprecated_member_use
        final pickedFile = await _picker.getImage(
          source: ImageSource.camera,
        );
        if (pickedFile != null) {
          if (isImageLesserThanDefinedSize(File(pickedFile.path))) {
            setState(() {
              uploadImage(pickedFile);
              // _cnicFrontFile = pickedFile;
            });

            return true;
          }
        }

        return true;
      } catch (e) {
        print(e.toString());
        return true;
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(isReadOnly ? Icons.edit : Icons.save),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: isReadOnly ? null : pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : (imageUrl != null
                      ? NetworkImage(imageUrl!)
                      : AssetImage('assets/default_profile.png')) as ImageProvider,
                  child: isReadOnly
                      ? null
                      : Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: nameController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: emailController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              style: TextStyle(color: Colors.black),
              controller: phoneController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
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
