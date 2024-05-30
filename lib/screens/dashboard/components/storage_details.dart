import 'package:admin/controllers/getAllmemberController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GetAllmemberController controller = Get.put(GetAllmemberController());
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
            "ຂໍ້ມູນສະມາຊິກທັງໝົດໃນລະບົບ",
            style: TextStyle(color: fontColorDefualt),
          ),
          const SizedBox(height: defaultPadding),
          const Chart(),
          Obx(
            () => StorageInfoCard(
              image: "assets/images/people.png",
              title: "ຈຳນວນລູກຄ້າທັງໝົດ",
              amountOfFiles: controller.customerCount.value.toString(),
              numOfFiles: 1328,
            ),
          ),
          Obx(
            () => StorageInfoCard(
              image: "assets/images/people.png",
              title: "ຈຳນວນສະມາຊິກຮ້ານສ້ອມແປງທັງໝົດ",
              amountOfFiles: controller.repairshopCount.value.toString(),
              numOfFiles: 1328,
            ),
          ),
          Obx(
            () => StorageInfoCard(
              image: "assets/images/people.png",
              title: "ຈຳນວນສະມາຊິກຮ້ານແກ່ລົດທັງໝົດ",
              amountOfFiles: controller.towingtruckCount.value.toString(),
              numOfFiles: 1328,
            ),
          )
        ],
      ),
    );
  }
}
