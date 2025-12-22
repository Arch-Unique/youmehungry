import 'package:youmehungry/src/features/auth/controllers/auth_controller.dart';
import 'package:youmehungry/src/features/dashboard/controllers/dashboard_controller.dart';
import 'package:youmehungry/src/features/dashboard/explorer_page.dart';
import 'package:youmehungry/src/features/shared.dart';
import 'package:youmehungry/src/global/ui/ui_barrel.dart';
import 'package:youmehungry/src/global/ui/widgets/others/containers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../src_barrel.dart';

class AddDestinationScreen extends StatefulWidget {
  const AddDestinationScreen({this.shdRestart = true, super.key});
  final bool shdRestart;

  @override
  State<AddDestinationScreen> createState() => _AddDestinationScreenState();
}

class _AddDestinationScreenState extends State<AddDestinationScreen> {
  final controller = AuthController();
  final dbController = Get.find<DashboardController>();

  @override
  void initState() {
    controller.initAllLocations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectivityWidget(
      child: SinglePageScaffold(
        title: "Choose Country",
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Obx(() {
            final list = List.generate(controller.country.length, (i) {
              return countryWidget(i, context);
            });
            return Column(
              children: [
                AppText.thin(
                  "Detty gives you the best deals on each location and is your tour guide",
                ),
                Ui.boxHeight(16),
                if (controller.locationLoading.value)
                  ShimmerContainer(
                    w: Ui.width(context) - 16,
                    h: Ui.height(context) / 4,
                    r: 16,
                  ),
                // Center(child: CircularProgress(48)),
                ...list,
              ],
            );
          }),
        ),
      ),
    );
  }

  GestureDetector countryWidget(int i, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // if (dbController.dbRepo.appService.currentUser.value.id != 0) {
        //   await dbController.dbRepo.updateLocation(
        //       controller.country[i].address,
        //       (controller.country[i].country ?? "Nigeria"),
        //       controller.country[i].id);
        // }

        if (widget.shdRestart) {
          dbController.resetInit();
          dbController.initApp(loc: controller.country[i]);
          Get.offAll(ExplorerScreen());
        } else {
          dbController.currentLocation.value = controller.country[i];
          Get.back();
          Ui.showInfo("Successfully changed country");
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Stack(
          children: [
            CurvedImage(
              controller.country[i].images[0],
              w: Ui.width(context) - 32,
              fit: BoxFit.cover,
              h: 0.66 * (Ui.width(context) - 32),
            ),
            // if((controller.country[i].country ?? "Nigeria") == "Special")
            // Container(
            //   width: Ui.width(context) - 32,
            //   height: (Ui.height(context) / 4),
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(16),
            //       gradient: LinearGradient(
            //           begin: Alignment.topCenter,
            //           end: Alignment.bottomCenter,
            //           colors: [
            //             AppColors.primaryColor.withOpacity(0),
            //             AppColors.primaryColor[900]!,
            //           ])),
            // ),
            // if((controller.country[i].country ?? "Nigeria") == "Special")
            // Positioned(
            //     bottom: 16,
            //     width: Ui.width(context) - 32,
            //     child: AppText.medium(
            //         (controller.country[i].country ?? "Nigeria") == "Special"
            //             ? "Detty Events"
            //             : (controller.country[i].country ?? "Nigeria"),
            //         fontSize: 40,
            //         alignment: TextAlign.center))
          ],
        ),
      ),
    );
  }
}
