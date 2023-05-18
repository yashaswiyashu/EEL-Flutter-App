import 'package:flutter/material.dart';
import 'package:flutter_app/models/product_details_model.dart';
import 'package:flutter_app/services/auth.dart';
import 'package:provider/provider.dart';

class DataTableExample extends StatefulWidget {
  const DataTableExample({super.key});
  
  @override
  State<DataTableExample> createState() => _DataTableExampleState();
}

class _DataTableExampleState extends State<DataTableExample> {
    final AuthService _auth = AuthService();

  List<List<String>> tableData = [
    ['', '', '', '', ''],
  ];

  List<String> options = ['Option 1', 'Option 2', 'Option 3'];
  List<String> selectedOptions = [];

  Widget _verticalDivider = const VerticalDivider(
        color: Colors.black,
        thickness: 0.5,
    );

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('Product')),
      DataColumn(label: Text('Quantity')),
      DataColumn(label: Text('unit price')),
      DataColumn(label: Text('Offer')),
      DataColumn(label: Text('Amount')),
    ];
  }

  void addRow() {
    setState(() {
      tableData.add(List.filled(5, ''));
      selectedOptions.add(options[0]);
    });
  }

  void onDropdownChanged(String? value, int rowIndex) {
    setState(() {
      selectedOptions[rowIndex] = value!;
      populateTable();
    });
  }

  void populateTable() {
    setState(() {
      for (int rowIndex = 0; rowIndex < tableData.length; rowIndex++) {
        for (int cellIndex = 0; cellIndex < 5; cellIndex++) {
          tableData[rowIndex][cellIndex] =
              '${selectedOptions[rowIndex]} ${rowIndex + 1}-$cellIndex';
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    selectedOptions = List.generate(tableData.length, (index) => options[0]);
  }

  @override
  Widget build(BuildContext context) {
    final productDetails = Provider.of<List<ProductDetailsModel>>(context);
    
    return Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: _createColumns(),
              rows: List.generate(
                tableData.length,
                (int rowIndex) {
                  return DataRow(
                    cells: List.generate(
                      5,
                      (int cellIndex) {
                        if (cellIndex == 0) {
                          return DataCell(
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedOptions[rowIndex],
                                  items: options
                                      .map<DropdownMenuItem<String>>(
                                        (String value) =>
                                            DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (String? value) {
                                    onDropdownChanged(value, rowIndex);
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                        return DataCell(
                          Text(tableData[rowIndex][cellIndex]),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff4d47c3),
              ),
              onPressed: addRow,
              child: const Text('Add +'),
            ),]
          ),
        ],
      );
  }
}