import 'package:admin/controllers/deleteTowingshopController.dart';
import 'package:admin/controllers/member/towingshopNotificationController.dart';
import 'package:admin/controllers/updatetowingshopController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:admin/constants.dart';

class TowingshopNotification extends StatefulWidget {
  const TowingshopNotification({Key? key}) : super(key: key);

  @override
  State<TowingshopNotification> createState() => _TowingshopNotificationState();
}

class _TowingshopNotificationState extends State<TowingshopNotification> {
  final TowingshopNotificationController _towingshopNotificationController =
      Get.put(TowingshopNotificationController());
  static int _rowsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _towingshopNotificationController.fetchTowingshopData();
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
              if (_towingshopNotificationController.towingshopData.isEmpty) {
                return const Center(
                  child: Text('ຍັງບໍ່ມີຂໍ້ຄວາມໃໝ່'),
                );
              }
              return PaginatedDataTable(
                header: const Text(
                  "ຂໍ້ມູນອະນຸມັດເປີດຮ້ານແກ່ລົດ",
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
                source: TowingshopDataSource(
                    _towingshopNotificationController.towingshopData),
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

class TowingshopDataSource extends DataTableSource {
  final List<Map<String, dynamic>> towingshopData;

  TowingshopDataSource(this.towingshopData);

  @override
  DataRow? getRow(int index) {
    if (index >= towingshopData.length) return null;
    final customer = towingshopData[index];
    return customerDataRow(customer);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => towingshopData.length;

  @override
  int get selectedRowCount => 0;
}

DataRow customerDataRow(Map<String, dynamic> towingshop) {
  final TowingshopNotificationController _towingshopNotificationController =
      Get.put(TowingshopNotificationController());
  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  NetworkImage(towingshop['profile_image']!.toString()),
            ),
          ],
        ),
      ),
      DataCell(Text(towingshop['id'].toString())),
      DataCell(Text(towingshop['shop_name'].toString())),
      DataCell(Text(towingshop['manager_name'].toString())),
      DataCell(Text(towingshop['tel'].toString())),
      DataCell(Text(towingshop['age'].toString())),
      DataCell(Text(towingshop['gender'].toString())),
      DataCell(Text(towingshop['birthdate'].toString())),
      DataCell(Text(towingshop['village'].toString())),
      DataCell(Text(towingshop['district'].toString())),
      DataCell(Text(towingshop['province'].toString())),
      DataCell(Text(towingshop['type_service'].toString())),
      DataCell(Text(towingshop['latitude'].toString())),
      DataCell(Text(towingshop['longitude'].toString())),
      DataCell(Text(towingshop['role'].toString())),
      DataCell(Text(towingshop['createdAt'].toString())),
      DataCell(Text(towingshop['updatedAt'].toString())),
      DataCell(
        Row(
          children: [
            // ElevatedButton(
            // onPressed: () async {
            //   //logic
            //   await _towingshopNotificationController.UpdatePermission(
            //       towingshop['id']);
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
                    //logic
                    await _towingshopNotificationController.UpdatePermission(
                        towingshop['id']);
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
                    _showDeleteConfirmationDialog(context, towingshop['id']);
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
  final DeleteTowingshopController deleteTowingshopController =
      Get.put(DeleteTowingshopController());

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
              await deleteTowingshopController.deleteTowingshop(repairshopId);
            },
          ),
        ],
      );
    },
  );
}

Future<void> _showUpdateTowingshopDialog(
    BuildContext context, Map<String, dynamic> towingshop) {
  final TextEditingController shopNameController =
      TextEditingController(text: towingshop['shop_name'].toString());
  final TextEditingController managerNameController =
      TextEditingController(text: towingshop['manager_name'].toString());
  final TextEditingController telController =
      TextEditingController(text: towingshop['tel'].toString());
  final TextEditingController ageController =
      TextEditingController(text: towingshop['age'].toString());
  final TextEditingController genderController =
      TextEditingController(text: towingshop['gender'].toString());
  final TextEditingController villageController =
      TextEditingController(text: towingshop['village'].toString());
  final TextEditingController districtController =
      TextEditingController(text: towingshop['district'].toString());
  final TextEditingController provinceController =
      TextEditingController(text: towingshop['province'].toString());
  final TextEditingController typeServiceController =
      TextEditingController(text: towingshop['type_service'].toString());
  final TextEditingController latitudeController =
      TextEditingController(text: towingshop['latitude'].toString());
  final TextEditingController longitudeController =
      TextEditingController(text: towingshop['longitude'].toString());
  final TextEditingController roleController =
      TextEditingController(text: towingshop['role'].toString());

  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      final UpdateTowingshopController updateTowingshopController =
          Get.put(UpdateTowingshopController());
      return AlertDialog(
        title: const Text('ອັບເດດຂໍ້ມູນຮ້ານແກ່ລົດ'),
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
                towingshop['shop_name'] = shopNameController.text;
                towingshop['manager_name'] = managerNameController.text;
                towingshop['tel'] = telController.text;
                towingshop['age'] = int.tryParse(ageController.text) ?? 0;
                towingshop['gender'] = genderController.text;
                towingshop['village'] = villageController.text;
                towingshop['district'] = districtController.text;
                towingshop['province'] = provinceController.text;
                towingshop['type_service'] = typeServiceController.text;
                towingshop['latitude'] = latitudeController.text;
                towingshop['longitude'] = longitudeController.text;
                towingshop['role'] = roleController.text;

                Navigator.of(context).pop();
                // Dispatch an event to update the customer using GetX
                await updateTowingshopController.updateTowingshop(towingshop);
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
