import 'dart:js';

import 'package:admin/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/controllers/member/customerController.dart';
import 'package:admin/controllers/deleteCustomerController.dart';
import 'package:intl/intl.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final CustomerController _customerController = Get.put(CustomerController());

  late CustomerDataSource _dataSource;
  static int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _customerController.fetchCustomer().then((_) {
      setState(() {
        _dataSource = CustomerDataSource(_customerController.customer);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Text(
          //   "ຕາຕະລາງຮ້ານສ້ອມແປງທີ່ມີຄະແນນສູງສຸດ",
          //   style: TextStyle(color: fontColorDefualt),
          // ),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              if (_customerController.customer.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return PaginatedDataTable(
                arrowHeadColor: Colors.blue,
                header: const Text(
                  "ລາຍຊື່ລູກຄ້າ",
                  style: TextStyle(color: fontColorDefualt),
                ),
                columns: const [
                  DataColumn(
                      label: Text("ຮູບprofile",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ID",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ຊື່ຜູ້ໃຊ້",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ນາມສະກຸນ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ເບີໂທ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ອາຍຸ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ເພດ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ວັນທີ່ເດືອນປີເກີດ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ບ້ານ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ເມືອງ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ແຂວງ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ບົດບາດ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("createdAt",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("updatedAt",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("Actions",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                ],
                source: _dataSource,
                rowsPerPage: _rowsPerPage,
                availableRowsPerPage: const [5, 10, 20],
                onRowsPerPageChanged: (rowsPerPage) {
                  setState(() {
                    _rowsPerPage = rowsPerPage!;
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class CustomerDataSource extends DataTableSource {
  final List<Map<String, dynamic>> customerData;

  CustomerDataSource(this.customerData);

  @override
  DataRow? getRow(int index) {
    if (index >= customerData.length) return null;
    final customer = customerData[index];
    return customerDataRow(customer);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => customerData.length;

  @override
  int get selectedRowCount => 0;
}

DataRow customerDataRow(Map<String, dynamic> customer) {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formattedBirthdate =
      formatter.format(DateTime.parse(customer['birthdate'].toString()));
  final DeleteCustomerController deleteCustomerController =
      Get.put(DeleteCustomerController());

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(customer['profile_image'].toString()),
            ),
          ],
        ),
      ),
      DataCell(Text(customer['id'].toString())),
      DataCell(Text(customer['first_name'].toString())),
      DataCell(Text(customer['last_name'].toString())),
      DataCell(Text(customer['tel'].toString())),
      DataCell(Text(customer['age'].toString())),
      DataCell(Text(customer['gender'].toString())),
      DataCell(Text(formattedBirthdate)),
      DataCell(Text(customer['village'].toString())),
      DataCell(Text(customer['district'].toString())),
      DataCell(Text(customer['province'].toString())),
      // DataCell(Text(customer['profile_image'].toString())),
      DataCell(Text(customer['role'].toString())),
      DataCell(Text(customer['createdAt'].toString())),
      DataCell(Text(customer['updatedAt'].toString())),
      DataCell(
        Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, customer['id']);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                // Implement the update logic as needed
              },
            ),
          ],
        ),
      ),
    ],
  );
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, String customerId) async {
  final DeleteCustomerController deleteCustomerController =
      Get.put(DeleteCustomerController());
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Delete'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Are you sure you want to delete this customer?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () async {
              Navigator.of(context).pop();
              await deleteCustomerController.deleteCustomer(customerId);
            },
          ),
        ],
      );
    },
  );
}
