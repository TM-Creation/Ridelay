import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/base url.dart';
import '../../config/compress_image.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import 'driver_main_screen.dart';
class DriverProfile extends StatefulWidget {
  @override
  _DriverProfileState createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
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
            DriverRideSelectionScreen.routeName);
      } else {
        // Handle API error
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
      print('Error: $error');
      Get.snackbar(
        'Error!',
        'Network error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: themeColor,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
      );
    }
  }
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
   var size=MediaQuery.sizeOf(context);
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
        backgroundColor: themeColor,
        automaticallyImplyLeading: false,
        title: Text('Profile',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        actions: [
          Row(
            children: [
              Text(isReadOnly ? 'Edit' : 'Save',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
              IconButton(
                icon: Icon(isReadOnly ? Icons.edit : Icons.save,color: Colors.white,),
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
              height: size.width*0.1,
            ),
            Center(
              child: GestureDetector(
                onTap: isReadOnly ? null : pickImage,
                child: CircleAvatar(
                  radius: size.width*0.13,
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
            SizedBox(height: size.width*0.2),
            TextField(
              style: TextStyle(color: themeColor,fontWeight: FontWeight.bold),
              controller: nameController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(color: themeColor,fontSize: size.width*0.05,fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: themeColor)
                ),
              ),
            ),
            SizedBox(height: size.width*0.1),
            TextField(
              style: TextStyle(color: themeColor,fontWeight: FontWeight.bold),
              controller: emailController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: themeColor,fontSize: size.width*0.05,fontWeight: FontWeight.bold),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: themeColor)
                ),
              ),
            ),
            SizedBox(height: size.width*0.1),
            TextField(
              style: TextStyle(color: themeColor,fontWeight: FontWeight.bold),
              controller: phoneController,
              readOnly: isReadOnly,
              decoration: InputDecoration(
                labelText: 'Phone',
                labelStyle: TextStyle(color: themeColor,fontSize: size.width*0.05,fontWeight: FontWeight.bold),
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
