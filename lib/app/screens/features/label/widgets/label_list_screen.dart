import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../../core/state_management/dispatch_events/dispatch_listener_event.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../home/home_screen.dart';
import '../../note/note_add_screen.dart';
import '../controllers/label_controller.dart';
import '../models/label_model.dart';
import 'package:google_fonts/google_fonts.dart';

import 'functions/label_widget.dart';
import 'label_add_screen.dart';

class LabelListScreen extends StatefulWidget {
  const LabelListScreen({super.key});

  @override
  State<LabelListScreen> createState() => _LabelListScreenState();
}

class _LabelListScreenState extends State<LabelListScreen> {
  List<LabelModel> labels = [];
  late LabelController controller;
  @override
  void initState() {
    // TODO: implement initState

    DispatchListenerEvent.listener("DISPATCH_GET_ALL_LABELS_FROM_DB",
        onGetAllLabelsFromDB, "DISPATCH_GET_ALL_LABELS_FROM_DB");

    DispatchListenerEvent.listener("DISPATCH_ADD_NEW_LABEL_TO_LIST",
        onAddNewLabelToList, "DISPATCH_ADD_NEW_LABEL_TO_LIST");

    DispatchListenerEvent.listener("DISPATCH_GET_RELOAD_LABEL_LIST",
        onGetReloadLabelList, "DISPATCH_GET_RELOAD_LABEL_LIST");

    DispatchListenerEvent.listener("DISPATCH_RELOAD_LABEL_LIST",
        onReloadLabelList, "DISPATCH_RELOAD_LABEL_LIST");

    super.initState();
  }

  onGetAllLabelsFromDB(List<LabelModel> allLabels) {
    setState(() {
      labels = allLabels;
    });
  }

  onAddNewLabelToList(LabelModel labelModel) {
    setState(() {
      labels.add(labelModel);
    });
  }

  onReloadLabelList(List<LabelModel> allLabels) {
    setState(() {
      labels = allLabels;
    });
  }

  onGetReloadLabelList(data) {
    controller.initData();
  }

  @override
  Widget build(BuildContext context) {
    LabelController controller = LabelController(context: context);
    if (labels.isEmpty) {
      controller.initData();
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.house, size: 18.0),
              label: const Text('Home'),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(
                            title: 'Hi Task',
                          )),
                  (route) => false,
                );
              },
              coreButtonStyle: CoreButtonStyle.options(
                  coreStyle: CoreStyle.outlined,
                  coreColor: CoreColor.success,
                  coreRadius: CoreRadius.radius_6,
                  kitForegroundColorOption: Colors.black,
                  coreFixedSizeButton: CoreFixedSizeButton.medium_40),
            ),
          )
        ],
        backgroundColor: const Color(0xff28a745),
        title: Text(
          'Labels',
          style:
              GoogleFonts.montserrat(fontStyle: FontStyle.italic, fontSize: 30),
        ),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => LabelWidget(
                label: labels[index],
                onTap: () async {},
                onLongPress: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              'Are you sure you want to delete this note?'),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.red)),
                              onPressed: () async {},
                              child: const Text('Yes'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('No'),
                            ),
                          ],
                        );
                      });
                },
              ),
          itemCount: labels.length),
      bottomNavigationBar: CoreBottomNavigationBar(
        backgroundColor: Colors.white,
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CoreElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen(
                              title: 'Hi Task',
                            )),
                    (route) => false,
                  );
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.home,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {},
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.search,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LabelAddScreen(
                            actionMode: ActionModeEnum.create)),
                  );
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.add,
                  size: 25.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
