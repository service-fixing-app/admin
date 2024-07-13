import 'dart:async';
import 'package:admin/controllers/getRequestRepairController.dart';
import 'package:admin/controllers/getRequestTowingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';

class RequestTowingReport extends StatefulWidget {
  const RequestTowingReport({Key? key}) : super(key: key);

  @override
  State<RequestTowingReport> createState() => _RequestTowingReportState();
}

class _RequestTowingReportState extends State<RequestTowingReport> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;

  final GetRequestTowingshopController _getRequestTowingshopController =
      Get.put(GetRequestTowingshopController());

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'id';
    _sortAscending = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic
    });
    _getRequestTowingshopController.fetchRequestRepairData();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_getRequestTowingshopController.requestRepairData.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: WebDataTable(
                header: const Text('ລາຍງານຈຳນວນຮ້ານສ້ອມແປງລົດ'),
                actions: [
                  if (_selectedRowKeys.isNotEmpty)
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red, // Background color
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          print('Delete!');
                          setState(() {
                            _selectedRowKeys.clear();
                          });
                        },
                      ),
                    ),
                  Container(
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'increment search...',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFFCCCCCC),
                          ),
                        ),
                      ),
                      onChanged: (text) {
                        _filterTexts = text.trim().split(' ');
                        _willSearch = false;
                        _latestTick = _timer?.tick;
                      },
                    ),
                  ),
                ],
                source: WebDataTableSource(
                  sortColumnName: _sortColumnName,
                  sortAscending: _sortAscending,
                  filterTexts: _filterTexts,
                  columns: [
                    WebDataColumn(
                      name: 'id',
                      label: const Text('ID'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'sender_name',
                      label: const Text('ຊື່ຜູ້ຮ້ອງຂໍບໍລິການ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'sender_tel',
                      label: const Text('ເບີໂທຜູ້ຮ້ອງຂໍບໍລິການ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'receiver_name',
                      label: const Text('ຊື່ຜູ້ຮັບຮ້ອງ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'receiver_tel',
                      label: const Text('ເບີໂທຜູ້ຮັບຮ້ອງ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'message',
                      label: const Text('ຂໍ້ຄວາມ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'status',
                      label: const Text('ສະຖານະ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'createdAt',
                      label: const Text('createAt'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'updatedAt',
                      label: const Text('updateAt'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                  ],
                  rows: _getRequestTowingshopController.requestRepairData,
                  selectedRowKeys: _selectedRowKeys,
                  onTapRow: (rows, index) {
                    print('onTapRow(): index = $index, row = ${rows[index]}');
                  },
                  onSelectRows: (keys) {
                    print(
                        'onSelectRows(): count = ${keys.length} keys = $keys');
                    setState(() {
                      _selectedRowKeys = keys;
                    });
                  },
                  primaryKeyName: 'id',
                ),
                horizontalMargin: 100,
                onPageChanged: (offset) {
                  print('onPageChanged(): offset = $offset');
                },
                onSort: (columnName, ascending) {
                  print(
                      'onSort(): columnName = $columnName, ascending = $ascending');
                  setState(() {
                    _sortColumnName = columnName;
                    _sortAscending = ascending;
                  });
                },
                onRowsPerPageChanged: (rowsPerPage) {
                  print('onRowsPerPageChanged(): rowsPerPage = $rowsPerPage');
                  setState(() {
                    if (rowsPerPage != null) {
                      _rowsPerPage = rowsPerPage;
                    }
                  });
                },
                rowsPerPage: _rowsPerPage,
              ),
            ),
          );
        }
      }),
    );
  }
}
