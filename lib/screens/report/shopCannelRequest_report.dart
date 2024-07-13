import 'dart:async';
import 'package:admin/controllers/deleteRepairshopController.dart';
import 'package:admin/controllers/getScoreTowingshopController.dart';
import 'package:admin/controllers/getShopTopCannellController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_data_table/web_data_table.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

class ShopCannelRequestReport extends StatefulWidget {
  const ShopCannelRequestReport({Key? key}) : super(key: key);

  @override
  State<ShopCannelRequestReport> createState() =>
      _ShopCannelRequestReportState();
}

class _ShopCannelRequestReportState extends State<ShopCannelRequestReport> {
  late String _sortColumnName;
  late bool _sortAscending;
  List<String>? _filterTexts;
  Timer? _timer;
  List<String> _selectedRowKeys = [];
  int _rowsPerPage = 10;
  late TextEditingController _dateRangeController;

  final GetTopShopCannelRequest _getTopShopCannelRequest =
      Get.put(GetTopShopCannelRequest());
  final DeleteRepairshopController deleteRepairshopController =
      Get.put(DeleteRepairshopController());

  @override
  void initState() {
    super.initState();
    _sortColumnName = 'cancelled_count';
    _sortAscending = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // Timer logic
    });
    _getTopShopCannelRequest.fetchshopData();

    _dateRangeController = TextEditingController(text: '');
  }

  // start code filter data by date
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {});
    }
  }

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

  // printing
  Future<void> _printDataTable() async {
    List<Map<String, dynamic>> rows = _getTopShopCannelRequest.shopcannelData;
    // Load the font
    final ByteData fontData =
        await rootBundle.load('assets/fonts/phetsarath_ot.ttf');
    final Uint8List fontBytes = fontData.buffer.asUint8List();
    final ttf = pw.Font.ttf(fontBytes.buffer.asByteData());
    final pdf = pw.Document();
    final headers = [
      'ລຳດັບ',
      'ລະຫັດຮ້ານ',
      'ຊື່ຮ້ານ',
      'ຈຳນວນທີ່ຍົກເລີກການຮ້ອງ',
    ];
    final data = rows.map((row) {
      return [
        row['sequence'],
        row['shop_id'],
        row['shop_name'],
        row['cancelled_count'],
      ];
    }).toList();

    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.TableHelper.fromTextArray(
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
        if (_getTopShopCannelRequest.shopcannelData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          var sortedData = List<Map<String, dynamic>>.from(
              _getTopShopCannelRequest.shopcannelData);
          sortedData.sort(
              (a, b) => a['cancelled_count'].compareTo(b['cancelled_count']));
          for (int i = 0; i < sortedData.length; i++) {
            sortedData[i]['sequence'] = i + 1;
          }
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  WebDataTable(
                    header: const Text('ລາຍງານຈຳນວນຮ້ານທີ່ຖືກຍົກເລີກ'),
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
                      Row(
                        children: [
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
                    ],
                    source: WebDataTableSource(
                      sortColumnName: _sortColumnName,
                      sortAscending: _sortAscending,
                      filterTexts: _filterTexts,
                      columns: [
                        WebDataColumn(
                          name: 'sequence',
                          label: const Text('ລຳດັບ'),
                          dataCell: (value) => DataCell(Text('$value')),
                        ),
                        WebDataColumn(
                          name: 'shop_id',
                          label: const Text('ລະຫັດຂອງຮ້ານ'),
                          dataCell: (value) => DataCell(
                            SizedBox(
                              width: 100,
                              child: Text('$value'),
                            ),
                          ),
                        ),
                        WebDataColumn(
                          name: 'shop_name',
                          label: const Text('ຊື່ຮ້ານສ້ອມແປງ'),
                          dataCell: (value) => DataCell(
                            SizedBox(
                              width: 200,
                              child: Text('$value'),
                            ),
                          ),
                        ),
                        WebDataColumn(
                          name: 'cancelled_count',
                          label: const Text('ຈຳນວນຄັ້ງທີີ່ຍົກເລີກ'),
                          dataCell: (value) => DataCell(
                            SizedBox(
                              width: 200,
                              child: Text('$value'),
                            ),
                          ),
                        ),
                      ],
                      rows: sortedData,
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
                      // print('onPageChanged(): offset = $offset');
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
