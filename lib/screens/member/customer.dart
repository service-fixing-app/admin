import 'package:admin/controllers/updatecustomerController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:admin/constants.dart';
import 'package:admin/controllers/member/customerController.dart';
import 'package:admin/controllers/deleteCustomerController.dart';

class Customer extends StatefulWidget {
  const Customer({Key? key}) : super(key: key);

  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final CustomerController _customerController = Get.put(CustomerController());
  static int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _customerController.fetchCustomer();
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
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              if (_customerController.customer.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return PaginatedDataTable(
                header: const Text(
                  "ຈັດການຂໍ້ມູນລູກຄ້າ",
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
                source: CustomerDataSource(_customerController.customer),
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
    if (index >= customerData.length || index < 0) return null;
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
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(customer['profile_image']!.toString()),
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
      DataCell(Text(customer['birthdate'].toString())),
      DataCell(Text(customer['village'].toString())),
      DataCell(Text(customer['district'].toString())),
      DataCell(Text(customer['province'].toString())),
      DataCell(Text(customer['role'].toString())),
      DataCell(Text(customer['createdAt'].toString())),
      DataCell(Text(customer['updatedAt'].toString())),
      DataCell(
        Row(
          children: [
            // Builder(
            //   builder: (context) => IconButton(
            //     icon: const Icon(Icons.delete, color: Colors.red),
            //     onPressed: () {
            //       _showDeleteConfirmationDialog(context, customer['id']);
            //     },
            //   ),
            // ),
            // Builder(builder: (context) {
            //   return IconButton(
            //     icon: const Icon(Icons.edit, color: Colors.blue),
            //     onPressed: () {
            //       _showUpdateCustomerDialog(context, customer);
            //     },
            //   );
            // }),
            Builder(
              builder: (context) => Tooltip(
                message: 'ລຶບ',
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, customer['id']);
                  },
                ),
              ),
            ),
            Builder(
              builder: (context) => Tooltip(
                message: 'ແກ້ໄຂ',
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    _showUpdateCustomerDialog(context, customer);
                  },
                ),
              ),
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
        title: const Text('ຢືນຢັນການລຶບ'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລຶບລູກຄ້ານີ້?'),
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
            child: const Text('ລຶບ'),
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

Future<void> _showUpdateCustomerDialog(
    BuildContext context, Map<String, dynamic> customer) {
  final TextEditingController firstNameController =
      TextEditingController(text: customer['first_name'].toString());
  final TextEditingController lastNameController =
      TextEditingController(text: customer['last_name'].toString());
  final TextEditingController telController =
      TextEditingController(text: customer['tel'].toString());
  final TextEditingController ageController =
      TextEditingController(text: customer['age'].toString());
  final TextEditingController genderController =
      TextEditingController(text: customer['gender'].toString());
  final TextEditingController villageController =
      TextEditingController(text: customer['village'].toString());
  final TextEditingController districtController =
      TextEditingController(text: customer['district'].toString());
  final TextEditingController provinceController =
      TextEditingController(text: customer['province'].toString());
  final TextEditingController roleController =
      TextEditingController(text: customer['role'].toString());

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // User must tap a button

    builder: (BuildContext context) {
      final UpdateCustomerController updateCustomerController =
          Get.put(UpdateCustomerController());
      return AlertDialog(
        title: const Text('ອັບເດດລູກຄ້າ'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'ຊື່​ລູກຄ້າ'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'ນາມ​ສະ​ກຸນ'),
              ),
              TextField(
                controller: telController,
                decoration: const InputDecoration(labelText: 'ໂທລະສັບ'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'ອາຍຸ'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'ເພດ'),
              ),
              TextField(
                controller: villageController,
                decoration: const InputDecoration(labelText: 'ບ້ານ'),
              ),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'ເມືອງ'),
              ),
              TextField(
                controller: provinceController,
                decoration: const InputDecoration(labelText: 'ແຂວງ'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'ບົດບາດ'),
              ),
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
            child: const Text('ອັບເດດ'),
            onPressed: () async {
              try {
                // Update the customer data
                customer['first_name'] = firstNameController.text;
                customer['last_name'] = lastNameController.text;
                customer['tel'] = telController.text;
                customer['age'] = int.tryParse(ageController.text) ?? 0;
                customer['gender'] = genderController.text;
                customer['village'] = villageController.text;
                customer['district'] = districtController.text;
                customer['province'] = provinceController.text;
                customer['role'] = roleController.text;

                Navigator.of(context).pop();
                await updateCustomerController.updateCustomer(customer);
              } catch (e) {
                // Handle errors
                print('Error updating customer: $e');
              }
            },
          ),
        ],
      );
    },
  );
}
