import 'dart:async';
import 'package:admin/controllers/getRepairshopController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';

class RepairshopReport extends StatefulWidget {
  const RepairshopReport({Key? key}) : super(key: key);

  @override
  State<RepairshopReport> createState() => _RepairshopReportState();
}

class _RepairshopReportState extends State<RepairshopReport> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  bool _willSearch = true;
  Timer? _timer;
  int? _latestTick;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;

  final GetRepairshopController _repairshopController =
      Get.put(GetRepairshopController());

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'id';
    _sortAscending = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic
    });
    _repairshopController
        .fetchRepairshopData(); // Fetch repair data when the widget is initialized
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
        if (_repairshopController.repairshopData.isEmpty) {
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
                          primary: Colors.red, // Background color
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
                  rows: _repairshopController.repairshopData,
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
