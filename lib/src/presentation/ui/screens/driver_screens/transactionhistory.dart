import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ridely/src/models/base%20url.dart';
import 'package:ridely/src/models/transactionhistoryandwallet.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';

import '../../../../infrastructure/screen_config/screen_config.dart';
import '../../templates/main_generic_templates/text_templates/display_text.dart';
import 'package:http/http.dart' as http;

class WalletService {
  Future<DriverWallet?> fetchDriverWallet() async {
    try {
      final response = await http.get(Uri.parse(
          '${baseulr().burl}/api/v1/driver/transections/66532d5b49a53711e9096838'));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return DriverWallet.fromJson(jsonResponse['data']);
      } else {
        throw Exception('Failed to load wallet data');
      }
    } catch (e) {
      throw Exception('Error occurred: $e');
    }
  }
}

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({Key? key}) : super(key: key);

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  late Future<DriverWallet?> futureWallet;

  @override
  void initState() {
    super.initState();
    futureWallet = WalletService().fetchDriverWallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Transaction History',
            style: TextStyle(
              fontSize: ScreenConfig.screenSizeWidth * 0.04,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: FutureBuilder<DriverWallet?>(
            future: futureWallet,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding:  EdgeInsets.only(top: ScreenConfig.screenSizeHeight*0.35),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No transaction data found'));
              } else {
                final wallet = snapshot.data!;
                return Column(
                  children: [
                    SizedBox(height: 50),
                    DataTable(
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => themeColor),
                      headingTextStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: ScreenConfig.screenSizeWidth * 0.03,
                      ),
                      dividerThickness: 1.0,
                      columns: [
                        DataColumn(label: Text('Date')),
                        DataColumn(label: Text('Time')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Amount')),
                      ],
                      rows: List.generate(
                        wallet.transactions.length,
                        (index) {
                          final transaction = wallet.transactions[index];
                          final dateTime = DateTime.parse(transaction.date);
                          final date =
                              "${dateTime.year}-${dateTime.month}-${dateTime.day}";
                          final time = "${dateTime.hour}:${dateTime.minute}";
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                date,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        ScreenConfig.screenSizeWidth * 0.03),
                              )),
                              DataCell(Text(
                                time,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        ScreenConfig.screenSizeWidth * 0.03),
                              )),
                              DataCell(Text(
                                transaction.type,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        ScreenConfig.screenSizeWidth * 0.03),
                              )),
                              DataCell(Text(
                                transaction.amount.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize:
                                        ScreenConfig.screenSizeWidth * 0.03),
                              )),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
