import 'package:admin/controllers/deleteRepairshopController.dart';
import 'package:admin/controllers/member/repairshopNotificationController.dart';
import 'package:admin/controllers/updateRepairshopController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/constants.dart';

class RepairshopNotification extends StatefulWidget {
  const RepairshopNotification({Key? key}) : super(key: key);

  @override
  State<RepairshopNotification> createState() => _RepairshopNotificationState();
}

class _RepairshopNotificationState extends State<RepairshopNotification> {
  final RepairshopNotificationController _repairshopNotificationController =
      Get.put(RepairshopNotificationController());
  static int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _repairshopNotificationController.fetchRepairshopData();
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
              if (_repairshopNotificationController.repairshopData.isEmpty) {
                return const Center(
                  child: Text('ຍັງບໍ່ມີຂໍ້ຄວາມໃໝ່'),
                );
              }
              return PaginatedDataTable(
                header: const Text(
                  "ຂໍ້ມູນອະນຸມັດເປີດຮ້ານສ້ອມແປງ",
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
                source: RepairshopDataSource(
                    _repairshopNotificationController.repairshopData),
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
  final RepairshopNotificationController _repairshopNotificationController =
      Get.put(RepairshopNotificationController());
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
            // ElevatedButton(
            //   onPressed: () async {
            //     //logic
            // await _repairshopNotificationController.UpdatePermission(
            //     repairshop['id']);
            //   },
            //   child: const Text('ອະນຸມັດເປີດຮ້ານ'),
            // ),
            Builder(
              builder: (context) => Tooltip(
                message: 'ອະນຸມັດເປີດຮ້ານ',
                child: IconButton(
                  icon:
                      const Icon(Icons.check_box_rounded, color: Colors.green),
                  onPressed: () async {
                    await _repairshopNotificationController.UpdatePermission(
                        repairshop['id']);
                  },
                ),
              ),
            ),
            Builder(
              builder: (context) => Tooltip(
                message: 'ລຶບ',
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, repairshop['id']);
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
    BuildContext context, String repairshopId) async {
  final DeleteRepairshopController deleteRepairshopController =
      Get.put(DeleteRepairshopController());

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('ຢືນຢັນການລຶບ'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('ທ່ານແນ່ໃຈບໍ່ວ່າຕ້ອງການລຶບຮ້ານສ້ອມແປງນີ້?'),
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
        title: const Text('ອັບເດດຂໍ້ມູນຮ້ານສ້ອມແປງ'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              TextField(
                controller: shopNameController,
                decoration: const InputDecoration(labelText: 'ຊື່ຮ້ານສ້ອມແປງ'),
              ),
              TextField(
                controller: managerNameController,
                decoration: const InputDecoration(labelText: 'ຊື່ເຈົ້າຂອງຮ້ານ'),
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
                controller: typeServiceController,
                decoration: const InputDecoration(labelText: 'ປະເພດການບໍລິການ'),
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
