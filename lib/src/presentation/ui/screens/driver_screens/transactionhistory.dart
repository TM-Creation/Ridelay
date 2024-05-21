import 'package:flutter/material.dart';

import '../../../../infrastructure/screen_config/screen_config.dart';
import '../../templates/main_generic_templates/text_templates/display_text.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory();

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> storehistory = [];
    final int length = 5;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Table(
            border: TableBorder.all(),
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(80), // Set width for the first column
              1: FixedColumnWidth(80),
              2: FlexColumnWidth(120), // Flex column width for the third column
              3: FixedColumnWidth(120), // Set width for the fourth column
            },
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: [
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      color: ScreenConfig.theme.primaryColor,
                      child: const Center(
                        child: Text(
                          "Date",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      color: ScreenConfig.theme.primaryColor,
                      child: const Center(
                        child: Text(
                          "Time",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      color: ScreenConfig.theme.primaryColor,
                      child: const Center(
                        child: Text(
                          "Type",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Container(
                      color: ScreenConfig.theme.primaryColor,
                      child: const Center(
                        child: Text(
                          "Costs",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (var i = 0; i < length; i++)
                TableRow(
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        child: const Center(
                          child: Text(
                            "12-5-22",
                            style: TextStyle(fontSize: 18,color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(

                        child: const Center(
                          child: Text(
                            "13:10",
                            style: TextStyle(fontSize: 18,color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        child: const Center(
                          child: Text(
                            "payment to indrive",
                            style: TextStyle(fontSize: 18,color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Container(
                        child: const Center(
                          child: Text(
                            "- PKR 19.48",
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
