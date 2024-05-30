import 'package:admin/controllers/getAllmemberController.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GetAllmemberController controller = Get.put(GetAllmemberController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return SizedBox(
          height: 200,
          child: Stack(
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  sections: controller.pieChartData,
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: defaultPadding),
                    Text(
                      controller.totalCount.value.toString(),
                      style: const TextStyle(
                        color: fontColorDefualt,
                        fontWeight: FontWeight.w600,
                        height: 0.5,
                      ),
                    ),
                    const Text(
                      "ຈຳນວນສະມາຊິກ",
                      style: TextStyle(color: fontColorDefualt),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
