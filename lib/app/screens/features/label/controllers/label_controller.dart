import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_detail_screen.dart';
import 'package:flutter_core_v3/app/services/database/database_provider.dart';
import 'package:get/get.dart';
import '../../../../../core/state_management/dispatch_events/dispatch_listener_event.dart';
import '../models/label_model.dart';
import '../widgets/label_detail_screen.dart';

class LabelController {

  BuildContext context;

  LabelController({required this.context});

  Future<void> initData() async {
    List<LabelModel>? labelsFromDB = await DatabaseProvider.getAllLabels();

    List<LabelModel> notes = <LabelModel>[];
    if (labelsFromDB != null) {
      notes = labelsFromDB;

      DispatchListenerEvent.dispatch('DISPATCH_GET_ALL_LABELS_FROM_DB', notes);
    }
  }

  Future<List<LabelModel>?> getAll() async {
    List<LabelModel>? labelsFromDB = await DatabaseProvider.getAllLabels();

    return labelsFromDB;
  }

  Future<bool> onCreateLabel(LabelModel note) async {
    try {
      int createdLabelId = await DatabaseProvider.addLabel(note);

      LabelModel? createdLabel =
      await DatabaseProvider.getLabelById(createdLabelId);

      if (createdLabel is LabelModel) {

        DispatchListenerEvent.dispatch(
            'DISPATCH_ADD_NEW_LABEL_TO_LIST', createdLabel);
      }
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<dynamic> onUpdateLabel(LabelModel label) async {
    try {
      int isUpdatedSuccess = await DatabaseProvider.updateLabel(label);

      if (isUpdatedSuccess.isEqual(1)) {
        LabelModel? updatedLabel = await DatabaseProvider.getLabelById(label.id!);

        if (updatedLabel is LabelModel) {
          return true;
        }
      }
    } catch (e) {
      return false;
    }

    return true;
  }
}
