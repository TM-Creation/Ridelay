import 'package:flutter/material.dart';
import 'package:ridely/src/presentation/ui/config/theme.dart';

import '../../../../infrastructure/screen_config/screen_config.dart';
import '../../templates/main_generic_templates/text_templates/display_text.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory();

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<Map<String, dynamic>> apiData = [
    {"id": 1, "name": "John Doe", "email": "john.doe@example.com","payment":"70"},
    {"id": 2, "name": "Jane Smith", "email": "jane.smith@example.com","payment":"70"},
    {"id": 1, "name": "John Doe", "email": "john.doe@example.com","payment":"70"},
    {"id": 2, "name": "Jane Smith", "email": "jane.smith@example.com","payment":"70"},
    {"id": 1, "name": "John Doe", "email": "john.doe@example.com","payment":"70"},
    {"id": 2, "name": "Jane Smith", "email": "jane.smith@example.com","payment":"70"},
    {"id": 1, "name": "John Doe", "email": "john.doe@example.com","payment":"70"},
    {"id": 2, "name": "Jane Smith", "email": "jane.smith@example.com","payment":"70"},
    // Add more entries based on your API response structure
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Transaction History',
            style: TextStyle(fontSize: ScreenConfig.screenSizeWidth*0.04,fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            DataTable(
              headingRowColor:
                  MaterialStateColor.resolveWith((states) => themeColor),
              // Styling for the entire DataTable
              headingTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: ScreenConfig.screenSizeWidth*0.03),
              //dataRowColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade100), // Background color of data rows
              dividerThickness: 1.0,
              // Thickness of cell dividers
              columns: [
                DataColumn(label: Text('Date')),
                DataColumn(label: Text('Time')),
                DataColumn(label: Text('Type')),
                DataColumn(label: Text('Payment'))
              ],
              rows: List.generate(
                apiData.length,
                (index) => DataRow(
                  cells: [
                    // Each DataCell with its own style
                    DataCell(
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          apiData[index]['id'].toString(),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          apiData[index]['name'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          apiData[index]['email'],
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          apiData[index]['id'].toString(),
                          style: TextStyle(color: Colors.black),
                        ),
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
