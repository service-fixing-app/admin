import 'dart:async';
import 'package:admin/controllers/deleteRequestRepairController.dart';
import 'package:admin/controllers/getRequestRepairController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class RequestRepariReport extends StatefulWidget {
  const RequestRepariReport({Key? key}) : super(key: key);

  @override
  State<RequestRepariReport> createState() => _RequestRepariReportState();
}

class _RequestRepariReportState extends State<RequestRepariReport> {
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

  final GetRequestRepairController _getRequestRepairController =
      Get.put(GetRequestRepairController());
  final DeleteRequestRepairController deleteRequestRepairController =
      Get.put(DeleteRequestRepairController());

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'id';
    _sortAscending = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic
    });
    _getRequestRepairController.fetchRequestRepairData();
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
      return _getRequestRepairController.requestRepairData;
    } else {
      return _getRequestRepairController.requestRepairData.where((row) {
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

  // printing
  Future<void> _printDataTable() async {
    List<Map<String, dynamic>> rows = getFilteredRows();
    // Load the font
    final ByteData fontData =
        await rootBundle.load('assets/fonts/phetsarath_ot.ttf');
    final Uint8List fontBytes = fontData.buffer.asUint8List();
    final ttf = pw.Font.ttf(fontBytes.buffer.asByteData());
    final pdf = pw.Document();
    final headers = [
      'ID',
      'sender_name',
      'sender_tel',
      'receiver_name',
      'receiver_tel',
      'message',
      'status',
      'createAt',
      'updateAt'
    ];
    final data = rows.map((row) {
      return [
        row['id'],
        row['sender_name'],
        row['sender_tel'],
        row['receiver_name'],
        row['receiver_tel'],
        row['message'],
        row['status'],
        row['createdAt'],
        row['updatedAt']
      ];
    }).toList();

    pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      build: (pw.Context context) {
        return pw.Table.fromTextArray(
          headers: headers,
          data: data,
          border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
          headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(font: ttf),
          headerDecoration: const pw.BoxDecoration(
            color: PdfColors.grey300,
          ),
          cellHeight: 30,
          cellAlignments: {
            for (var i = 0; i < headers.length; i++) i: pw.Alignment.centerLeft,
          },
          cellPadding: const pw.EdgeInsets.all(4),
          oddRowDecoration: const pw.BoxDecoration(
            color: PdfColors.grey100,
          ),
        );
      },
    ));

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_getRequestRepairController.requestRepairData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<Map<String, dynamic>> filteredRows = getFilteredRows();
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
                          backgroundColor: Colors.red,
                        ),
                        onPressed: _selectedRowKeys.isNotEmpty
                            ? () {
                                _showDeleteConfirmationDialog(context, () {
                                  deleteRequestRepairController
                                      .deleteCustomer(_selectedRowKeys);
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
                                icon: const Icon(Icons.calendar_month_outlined),
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
                            onPressed: _printDataTable,
                            child: const Row(
                              children: [
                                Icon(Icons.print),
                                SizedBox(width: 10),
                                Text('ພິມ'),
                              ],
                            ),
                          ),
                        )
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
                  rows: filteredRows,
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
