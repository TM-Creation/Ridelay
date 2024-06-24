import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pinput/pinput.dart';

import '../../../../infrastructure/screen_config/screen_config.dart';
class Wallet extends StatefulWidget {
  const Wallet();

  @override
  State<Wallet> createState() => _WalletState();
}
class _WalletState extends State<Wallet> {

  @override
  Widget build(BuildContext context) {
    final Height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    final TextEditingController _jazzCashNumberController = TextEditingController();
    final TextEditingController _amountController = TextEditingController();
    final TextEditingController _mpinController = TextEditingController();
    bool flagJazzCash = false;
    bool flagEasyPaisa = false;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(169, 169, 169, 1)),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Colors.red),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    void _clearInputFields() {
      _jazzCashNumberController.clear();
      _amountController.clear();
      _mpinController.clear();
    }
    var balance = 200;
    var payout_schedule = "December 20";
    Future<bool> _validateMPIN(String mpin) async {
      String jazzCashNumber = _jazzCashNumberController.text;

      // Replace with your actual JazzCash API endpoint for MPIN validation
      String url = 'https://api.jazzcash.com/validateMPIN';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'jazzCashNumber': jazzCashNumber,
            'mpin': mpin,
          }),
        );

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          return responseBody['valid']; // Assuming the API returns a 'valid' field indicating MPIN validity
        } else {
          return false;
        }
      } catch (e) {
        print('Error validating MPIN: $e');
        return false;
      }
    }

    Future<void> _processPayment() async {
      String jazzCashNumber = _jazzCashNumberController.text;
      String amount = _amountController.text;
      String storedNumber = '03071464925';

      // Replace with your actual JazzCash API endpoint
      String url = 'https://api.jazzcash.com/payment';

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode(<String, String>{
            'jazzCashNumber': jazzCashNumber,
            'amount': amount,
            'storedNumber': storedNumber,
            'mpin': _mpinController.text,
          }),
        );

        if (response.statusCode == 200) {
          var responseBody = json.decode(response.body);
          if (responseBody['success']) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment of $amount to $storedNumber via JazzCash is processed.')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${responseBody['message']}')));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: ${response.reasonPhrase}')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
      } finally {
        _clearInputFields(); // Clear input fields after processing payment
      }
    }
    void _showMPINDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter MPIN'),
            content: Column(
              mainAxisSize: MainAxisSize.min, // Ensures the column only takes the space it needs
              children: [
                Pinput(
                  length: flagJazzCash ? 4 : flagEasyPaisa ? 5 : 0,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  controller: _mpinController, // Make sure you control the input
                  // validator: (s) {
                  //   return s == '22' ? null : 'Pin is incorrect';
                  // },
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  showCursor: true,
                  onCompleted: (pin) => print(pin),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Confirm'),
                onPressed: () async {
                  bool isValidMPIN = await _validateMPIN(_mpinController.text);
                  if (isValidMPIN) {
                    _processPayment();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Invalid MPIN')));
                  }
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  _clearInputFields();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).then((_) {
        _clearInputFields(); // Clear input fields when the dialog is closed
      });
    }
    void _showJazzCashPaymentDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(flagJazzCash? 'JazzCash Payment':flagEasyPaisa ? 'EasyPaisa Payment': 'Payment' ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _jazzCashNumberController,
                  decoration: InputDecoration(labelText: flagJazzCash? 'JazzCash Number':flagEasyPaisa ? 'EasyPaisa Number': 'Number' ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Send'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showMPINDialog(context);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  _clearInputFields();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      ).then((_) {
        _clearInputFields(); // Clear input fields when the dialog is closed
      });
    }
    void _showPaymentMethodsBottomSheet(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.24,
            decoration: BoxDecoration(
              color: Color(0XFFf6f6f6),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Methods', style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.073,color: ScreenConfig.theme.primaryColor)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: ScreenConfig.screenSizeWidth*0.22,
                        width: ScreenConfig.screenSizeWidth*0.22,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              flagJazzCash = true;
                            });
                            Navigator.of(context).pop(); // Close the bottom sheet
                            _showJazzCashPaymentDialog(context);
                          },
                          child: Image.asset("assets/images/jazzcash.jpeg", height: 100, width: 100),
                        ),
                      ),
                      SizedBox(
                        height: ScreenConfig.screenSizeWidth*0.13,
                        width: ScreenConfig.screenSizeWidth*0.13,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              flagEasyPaisa = true;
                            });
                            Navigator.of(context).pop(); // Close the bottom sheet
                            _showJazzCashPaymentDialog(context);

                          },
                            child: Image.asset("assets/images/easypaisa.png", height: 50, width: 50)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    void _showTermsAndConditionsDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Terms and Conditions',style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('1. Term 1: Description of term 1.',style: TextStyle(color: Colors.black),),
                  SizedBox(height: 10),
                  Text('2. Term 1: Description of term 2.',style: TextStyle(color: Colors.black),),
                  SizedBox(height: 10),
                  Text('3. Term 1: Description of term 3.',style: TextStyle(color: Colors.black),),
                  SizedBox(height: 10),
                  Text('4. Term 1: Description of term 4.',style: TextStyle(color: Colors.black),),
                  SizedBox(height: 10),
                  Text('5. Term 1: Description of term 5.',style: TextStyle(color: Colors.black),),
                  SizedBox(height: 10),
                  Text('6. Term 1: Description of term 6.',style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         leading:  IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: ScreenConfig.theme.primaryColor
              ))
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Wallet",
              style: TextStyle(fontSize: Width * 0.073, fontWeight: FontWeight.w500,color: ScreenConfig.theme.primaryColor),
            ),
            SizedBox(height: Height * 0.02),
            Container(
              width: double.infinity,
              height: Height * 0.24,
              decoration: BoxDecoration(
                color:ScreenConfig.theme.primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: Width * 0.05, right: Width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Height * 0.022),
                    Text("Balance", style: TextStyle(fontSize: Width * 0.05)),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${balance}.00",
                          style: TextStyle(fontSize: Width * 0.074, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: Width * 0.02),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text("PKR"),
                        ),
                      ],
                    ),
                    SizedBox(height: Height * 0.01),
                    Text(
                      "Payout scheduled: $payout_schedule",
                      style: TextStyle(color: Color(0XFFaeaeae), fontSize: Width * 0.045),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Height * 0.04),
            GestureDetector(
              onTap: () => _showPaymentMethodsBottomSheet(context),
              child: Container(
                width: double.infinity,
                height: Height * 0.05,
                decoration: BoxDecoration(
                  color: ScreenConfig.theme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: Width * 0.05, right: Width * 0.05),
                  child: Row(
                    children: [
                      Icon(
                        Icons.payment_outlined,
                        color: Colors.white,
                        size: Width * 0.055,
                      ),
                      SizedBox(width: Width * 0.05),
                      Text(
                        "Payment Methods",
                        style: TextStyle(fontSize: Width * 0.04, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: Height * 0.035),
            GestureDetector(
              onTap: () => _showTermsAndConditionsDialog(context),
              child: Container(
                width: double.infinity,
                height: Height * 0.05,
                decoration: BoxDecoration(
                  color: ScreenConfig.theme.primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: Width * 0.05, right: Width * 0.05),
                  child: Row(
                    children: [
                      ImageIcon(AssetImage('assets/images/terms_and_conditions.png'),color: Colors.white,),
                      SizedBox(width: Width * 0.05),
                      Text(
                        "Terms and conditions",
                        style: TextStyle(fontSize: Width * 0.04, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
