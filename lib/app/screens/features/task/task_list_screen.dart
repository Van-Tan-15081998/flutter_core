import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/task/models/task_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../library/enums/CommonEnums.dart';
import '../../home/home_screen.dart';
import '../label/models/label_model.dart';
import '../label/providers/label_notifier.dart';
import 'providers/task_notifier.dart';
import 'task_create_screen.dart';
import 'widgets/task_widget.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<LabelModel> labels = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getTaskLabels(String jsonLabelIds) {
    List<LabelModel>? noteLabels = [];
    List<dynamic> labelIds = jsonDecode(jsonLabelIds);

    noteLabels = context.watch<LabelNotifier>().labels!.where((model) => labelIds.contains(model.id)).toList();
    return noteLabels;
  }

  @override
  Widget build(BuildContext context) {
    // List<TaskModel>? myTasks = context.watch<TaskNotifier>().tasks;

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
          'Tasks',
          style:
              GoogleFonts.montserrat(fontStyle: FontStyle.italic, fontSize: 30),
        ),
      ),
      body: context.watch<TaskNotifier>().tasks != null
          ? ListView.builder(
              itemBuilder: (context, index) => TaskWidget(
                    task: context.watch<TaskNotifier>().tasks![index],
                    labels: getTaskLabels(context.watch<TaskNotifier>().tasks![index].labels!),
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskCreateScreen(
                                    task: context.watch<TaskNotifier>().tasks![index],
                                    actionMode: ActionModeEnum.update,
                                  )));
                      setState(() {});
                    },
                  ),
              itemCount: context.watch<TaskNotifier>().tasks!.length)
          : const Text('Empty list'),
    );
  }
}
