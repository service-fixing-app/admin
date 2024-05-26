import 'dart:async';
import 'package:admin/constants.dart';
import 'package:admin/controllers/deleteCustomerController.dart';
import 'package:admin/controllers/member/customerController.dart';
import 'package:admin/controllers/member/towingshopController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';

class Towingshop extends StatefulWidget {
  const Towingshop({Key? key}) : super(key: key);

  @override
  State<Towingshop> createState() => _TowingshopState();
}

class _TowingshopState extends State<Towingshop> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;

  final TowingshopController _towingshopController =
      Get.put(TowingshopController());
  final DeleteCustomerController deleteCustomerController =
      Get.put(DeleteCustomerController());

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'id';
    _sortAscending = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic
    });
    _towingshopController.fetchTowingshopData();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Function onConfirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ຢືນຢັນການລືບລາຍການຂອງທ່ານ'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('ທ່ານຕ້ອງການລືບລາຍການທີ່ທ່ານເລືອກໄວ້ນີ້ແທ້ບໍ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ຍົກເລີກ'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('ຕົກລົງ'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call the delete function
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_towingshopController.towingshopData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: WebDataTable(
                header: const Text('ຈັດການຂໍ້ມູນຮ້ານແກ່ລົດ'),
                actions: [
                  if (_selectedRowKeys.isNotEmpty) ...[
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, () {
                            deleteCustomerController
                                .deleteCustomer(_selectedRowKeys);
                            setState(() {
                              _selectedRowKeys.clear();
                            });
                          });
                        },
                        child: const Text(
                          'ລຶບຂໍ້ມູນ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8), // Add space between buttons
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                        ),
                        onPressed: () {
                          // Add your update logic here
                        },
                        child: const Text(
                          'ແກ້ໄຂຂໍ້ມູນ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 300, // specify a finite width
                    child: TextField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'ຄົ້ນຫາ...',
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
                      name: 'shop_name',
                      label: const Text('ຊື່ຮ້ານສ້ອມແປງ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'manager_name',
                      label: const Text('ຊື່ເຈົ້າຂອງຮ້ານ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'tel',
                      label: const Text('ເບີໂທ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'password',
                      label: const Text('ລະຫັດຜ່ານ'),
                      dataCell: (value) => const DataCell(Text('********')),
                    ),
                    WebDataColumn(
                      name: 'age',
                      label: const Text('ອາຍຸ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'gender',
                      label: const Text('ເພດ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'birthdate',
                      label: const Text('ວັນເດືອນປີເກີດ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'village',
                      label: const Text('ບ້ານ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'district',
                      label: const Text('ເມືອງ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'province',
                      label: const Text('ແຂວງ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'type_service',
                      label: const Text('ປະເພດໃຫ້ບໍລິການ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'profile_image',
                      label: const Text('ຮູບ profile'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'document_verify',
                      label: const Text('ຮູບເອກະສານຢືນຢັນຕົວຕົນ'),
                      dataCell: (value) => DataCell(Text('$value')),
                    ),
                    WebDataColumn(
                      name: 'role',
                      label: const Text('role'),
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
                  rows: _towingshopController.towingshopData,
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
