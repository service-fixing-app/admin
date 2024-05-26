import 'package:admin/controllers/getScoreRapairshopController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constants.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the controller
    final GetScoreRepairshopController _repairshopScoreController =
        Get.put(GetScoreRepairshopController());

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "ຕາຕະລາງຮ້ານສ້ອມແປງທີ່ມີຄະແນນສູງສຸດ",
            style: TextStyle(color: fontColorDefualt),
          ),
          SizedBox(
            width: double.infinity,
            child: Obx(() {
              // Create a copy of the repairScoreData list
              var sortedData = List<Map<String, dynamic>>.from(
                  _repairshopScoreController.repairScoreData);

              // Sort the list by average rating in descending order
              sortedData.sort((a, b) => b['average'].compareTo(a['average']));

              // Rebuild the DataTable when the repairScoreData changes
              return DataTable(
                columnSpacing: defaultPadding,
                // minWidth: 600,
                columns: const [
                  DataColumn(
                    label: Text(
                      "ID",
                      style: TextStyle(color: fontColorDefualt),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "ຊື່ຮ້ານສ້ອມແປງ",
                      style: TextStyle(color: fontColorDefualt),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      "ຄະແນນ",
                      style: TextStyle(color: fontColorDefualt),
                    ),
                  ),
                  // DataColumn(
                  //   label: Text(
                  //     "ຄະແນນ",
                  //     style: TextStyle(color: fontColorDefualt),
                  //   ),
                  // ),
                ],
                rows: List.generate(
                  sortedData.length,
                  (index) => repairshopDataRow(sortedData[index]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// Create a DataRow from the repair shop data
DataRow repairshopDataRow(Map<String, dynamic> repairShop) {
  return DataRow(
    cells: [
      DataCell(
        Text(
          repairShop['shop_id'].toString(),
          style: const TextStyle(color: fontColorDefualt),
        ),
      ),
      DataCell(Text(repairShop['shop_name'].toString())),
      DataCell(Text(repairShop['average'].toString())),
      // DataCell(
      //   Row(
      //     children: [
      //       IconButton(
      //         icon: Icon(Icons.delete, color: Colors.red),
      //         onPressed: () {
      //           // controller.deleteRepairShop(repairShop['shop_id'].toString());
      //         },
      //       ),
      //       IconButton(
      //         icon: Icon(Icons.edit, color: Colors.blue),
      //         onPressed: () {
      //           // Implement the actual update logic as needed
      //           // For example, show a dialog or navigate to another screen to update
      //         },
      //       ),
      //     ],
      //   ),
      // ),
    ],
  );
}
