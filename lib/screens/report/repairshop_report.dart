import 'dart:async';
import 'package:admin/controllers/deleteRepairshopController.dart';
import 'package:admin/controllers/getRepairshopController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  late TextEditingController _dateRangeController;
  DateTime? _startDate;
  DateTime? _endDate;

  final GetRepairshopController _repairshopController =
      Get.put(GetRepairshopController());
  final DeleteRepairshopController deleteRepairshopController =
      Get.put(DeleteRepairshopController());

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'id';
    _sortAscending = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic
    });
    _repairshopController.fetchRepairshopData();
    _startDate = null;
    _endDate = null;
    _dateRangeController = TextEditingController(text: '');
  }

  // start code filter data by date
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatDateRange(DateTime? startDate, DateTime? endDate) {
    String start = startDate != null ? _formatDate(startDate) : '';
    String end = endDate != null ? _formatDate(endDate) : '';
    return '$start - $end';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _dateRangeController.text = _formatDateRange(_startDate, _endDate);
      });
    }
  }

  List<Map<String, dynamic>> getFilteredRows() {
    if (_startDate == null && _endDate == null) {
      return _repairshopController.repairshopData;
    } else {
      return _repairshopController.repairshopData.where((row) {
        DateTime createdAt = DateTime.parse(row['createdAt']);
        bool isInDateRange = true;
        if (_startDate != null && _endDate != null) {
          isInDateRange =
              createdAt.isAfter(_startDate!) && createdAt.isBefore(_endDate!);
        } else if (_startDate != null) {
          isInDateRange = createdAt.isAfter(_startDate!);
        } else if (_endDate != null) {
          isInDateRange = createdAt.isBefore(_endDate!);
        }

        return isInDateRange;
      }).toList();
    }
  }

  // end code filter data by date

  @override
  void dispose() {
    super.dispose();
    _dateRangeController.dispose();
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
        if (_repairshopController.repairshopData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<Map<String, dynamic>> filteredRows = getFilteredRows();
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  WebDataTable(
                    header: const Text('ລາຍງານຈຳນວນຮ້ານສ້ອມແປງລົດ'),
                    actions: [
                      if (_selectedRowKeys.isNotEmpty)
                        SizedBox(
                          height: 50,
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: _selectedRowKeys.isNotEmpty
                                ? () {
                                    _showDeleteConfirmationDialog(context, () {
                                      deleteRepairshopController
                                          .deleteRepairshop(_selectedRowKeys);
                                      //print('Delete! $_selectedRowKeys');
                                      setState(() {
                                        _selectedRowKeys.clear();
                                      });
                                    });
                                  }
                                : null,
                            child: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      Container(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                controller: _dateRangeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: 'ວັນທີ່ເລີ່ມ - ວັນທີ່ຈົບ',
                                  labelStyle: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'phetsarath_ot',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                        Icons.calendar_month_outlined),
                                    onPressed: () => _selectDateRange(context),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              height: 50,
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  // Change button color as needed
                                ),
                                onPressed: () {},
                                child: const Row(
                                  children: [
                                    Icon(Icons.print),
                                    SizedBox(width: 10),
                                    Text('ພິມ'),
                                  ],
                                ),
                              ),
                            )
                            // TextField(
                            //   decoration: const InputDecoration(
                            //     prefixIcon: Icon(Icons.search),
                            //     hintText: 'ຄົ້ນຫາ...',
                            //     focusedBorder: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //         color: Color(0xFFCCCCCC),
                            //       ),
                            //     ),
                            //     border: OutlineInputBorder(
                            //       borderSide: BorderSide(
                            //         color: Color(0xFFCCCCCC),
                            //       ),
                            //     ),
                            //   ),
                            //   onChanged: (text) {
                            //     _filterTexts = text.trim().split(' ');
                            //     _willSearch = false;
                            //     _latestTick = _timer?.tick;
                            //   },
                            // ),
                          ],
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
                      rows: filteredRows,
                      selectedRowKeys: _selectedRowKeys,
                      onTapRow: (rows, index) {
                        print(
                            'onTapRow(): index = $index, row = ${rows[index]}');
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
                      print(
                          'onRowsPerPageChanged(): rowsPerPage = $rowsPerPage');
                      setState(() {
                        if (rowsPerPage != null) {
                          _rowsPerPage = rowsPerPage;
                        }
                      });
                    },
                    rowsPerPage: _rowsPerPage,
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
