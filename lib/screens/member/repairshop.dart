import 'package:admin/controllers/deleteRepairshopController.dart';
import 'package:admin/controllers/member/repairshopController.dart';
import 'package:admin/controllers/updateRepairshopController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/constants.dart';

class Repairshop extends StatefulWidget {
  const Repairshop({Key? key}) : super(key: key);

  @override
  State<Repairshop> createState() => _RepairshopState();
}

class _RepairshopState extends State<Repairshop> {
  final RepairshopController _repairshopController =
      Get.put(RepairshopController());
  static int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _repairshopController.fetchRepairshopData();
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
              if (_repairshopController.repairshopData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return PaginatedDataTable(
                header: const Text(
                  "ຂໍ້ມູນຮ້ານສ້ອມແປງ",
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
                      label: Text("ຊື່ຮ້ານສ້ອມແປງ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("ຊື່ເຈົ້າຂອງຮ້ານ",
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
                      label: Text("ປະເພດໃຫ້ບໍລິການ",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("latitude",
                          style: TextStyle(
                              color: fontColorDefualt,
                              fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text("longitude",
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
                source:
                    RepairshopDataSource(_repairshopController.repairshopData),
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

class RepairshopDataSource extends DataTableSource {
  final List<Map<String, dynamic>> reapairshopData;

  RepairshopDataSource(this.reapairshopData);

  @override
  DataRow? getRow(int index) {
    if (index >= reapairshopData.length) return null;
    final repairshop = reapairshopData[index];
    return customerDataRow(repairshop);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => reapairshopData.length;

  @override
  int get selectedRowCount => 0;
}

DataRow customerDataRow(Map<String, dynamic> repairshop) {
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(repairshop['profile_image']!.toString()),
            ),
          ],
        ),
      ),
      DataCell(Text(repairshop['id'].toString())),
      DataCell(Text(repairshop['shop_name'].toString())),
      DataCell(Text(repairshop['manager_name'].toString())),
      DataCell(Text(repairshop['tel'].toString())),
      DataCell(Text(repairshop['age'].toString())),
      DataCell(Text(repairshop['gender'].toString())),
      DataCell(Text(repairshop['birthdate'].toString())),
      DataCell(Text(repairshop['village'].toString())),
      DataCell(Text(repairshop['district'].toString())),
      DataCell(Text(repairshop['province'].toString())),
      DataCell(Text(repairshop['type_service'].toString())),
      DataCell(Text(repairshop['latitude'].toString())),
      DataCell(Text(repairshop['longitude'].toString())),
      DataCell(Text(repairshop['role'].toString())),
      DataCell(Text(repairshop['createdAt'].toString())),
      DataCell(Text(repairshop['updatedAt'].toString())),
      DataCell(
        Row(
          children: [
            Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _showDeleteConfirmationDialog(context, repairshop['id']);
                },
              ),
            ),
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _showUpdateRepairshopDialog(context, repairshop);
                },
              );
            }),
          ],
        ),
      ),
    ],
  );
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, String repairshopId) async {
  final DeleteRepairshopController deleteRepairshopController =
      Get.put(DeleteRepairshopController());

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
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
              await deleteRepairshopController.deleteRepairshop(repairshopId);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showUpdateRepairshopDialog(
    BuildContext context, Map<String, dynamic> repairshop) {
  final TextEditingController shopNameController =
      TextEditingController(text: repairshop['shop_name'].toString());
  final TextEditingController managerNameController =
      TextEditingController(text: repairshop['manager_name'].toString());
  final TextEditingController telController =
      TextEditingController(text: repairshop['tel'].toString());
  final TextEditingController ageController =
      TextEditingController(text: repairshop['age'].toString());
  final TextEditingController genderController =
      TextEditingController(text: repairshop['gender'].toString());
  final TextEditingController villageController =
      TextEditingController(text: repairshop['village'].toString());
  final TextEditingController districtController =
      TextEditingController(text: repairshop['district'].toString());
  final TextEditingController provinceController =
      TextEditingController(text: repairshop['province'].toString());
  final TextEditingController typeServiceController =
      TextEditingController(text: repairshop['type_service'].toString());
  final TextEditingController latitudeController =
      TextEditingController(text: repairshop['latitude'].toString());
  final TextEditingController longitudeController =
      TextEditingController(text: repairshop['longitude'].toString());
  final TextEditingController roleController =
      TextEditingController(text: repairshop['role'].toString());

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final UpdateRepairshopController updateRepairshopController =
          Get.put(UpdateRepairshopController());
      return AlertDialog(
        title: const Text('Update Customer'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: shopNameController,
                decoration: const InputDecoration(labelText: 'Shop Name'),
              ),
              TextField(
                controller: managerNameController,
                decoration: const InputDecoration(labelText: 'Manager Name'),
              ),
              TextField(
                controller: telController,
                decoration: const InputDecoration(labelText: 'Telephone'),
              ),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: genderController,
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              TextField(
                controller: villageController,
                decoration: const InputDecoration(labelText: 'Village'),
              ),
              TextField(
                controller: districtController,
                decoration: const InputDecoration(labelText: 'District'),
              ),
              TextField(
                controller: provinceController,
                decoration: const InputDecoration(labelText: 'Province'),
              ),
              TextField(
                controller: typeServiceController,
                decoration: const InputDecoration(labelText: 'TypeService'),
              ),
              TextField(
                controller: latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
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
            child: const Text('Update'),
            onPressed: () async {
              try {
                // Update the customer data
                repairshop['shop_name'] = shopNameController.text;
                repairshop['manager_name'] = managerNameController.text;
                repairshop['tel'] = telController.text;
                repairshop['age'] = int.tryParse(ageController.text) ?? 0;
                repairshop['gender'] = genderController.text;
                repairshop['village'] = villageController.text;
                repairshop['district'] = districtController.text;
                repairshop['province'] = provinceController.text;
                repairshop['type_service'] = typeServiceController.text;
                repairshop['latitude'] = latitudeController.text;
                repairshop['longitude'] = longitudeController.text;
                repairshop['role'] = roleController.text;

                Navigator.of(context).pop();
                // Dispatch an event to update the customer using GetX
                await updateRepairshopController.updateRepairshop(repairshop);
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
