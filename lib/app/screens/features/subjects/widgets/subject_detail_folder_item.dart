import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/extensions/extensions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/containment/dialogs/CoreFullScreenDialog.dart';
import '../../../../../core/components/helper_widgets/CoreHelperWidget.dart';
import '../../../../../core/components/notifications/CoreNotification.dart';
import '../../../../library/common/converters/CommonConverters.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../../note/models/note_condition_model.dart';
import '../../note/note_create_screen.dart';
import '../../note/note_list_screen.dart';
import '../databases/subject_db_manager.dart';
import '../models/subject_condition_model.dart';
import '../models/subject_model.dart';
import '../providers/subject_notifier.dart';
import 'subject_create_screen.dart';
import 'subject_list_screen.dart';

class SubjectDetailFolderItem extends StatefulWidget {
  final SubjectModel? subject;
  final RedirectFromEnum? redirectFrom;
  final Widget subjectFoldersWidget;
  final Widget notesWidget;
  final Widget breadcrumbWidget;

  const SubjectDetailFolderItem(
      {super.key,
      required this.subject,
      required this.redirectFrom,
      required this.subjectFoldersWidget,
      required this.notesWidget,
      required this.breadcrumbWidget});

  @override
  State<SubjectDetailFolderItem> createState() =>
      _SubjectDetailFolderItemState();
}

class _SubjectDetailFolderItemState extends State<SubjectDetailFolderItem> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _buildBody(context, settingNotifier)),
    );
  }

  Widget _buildBody(BuildContext context, SettingNotifier settingNotifier) {
    return Column(
      children: [
        widget.breadcrumbWidget,
        Expanded(
          child: TabBarView(
            children: [
              Column(
                children: [
                  Container(
                    margin: settingNotifier.isSetBackgroundImage ==
                        true
                        ? const EdgeInsets.fromLTRB(0, 2.0, 0, 2.0)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(12)),
                        color: settingNotifier.isSetBackgroundImage ==
                            true
                            ? Colors.white.withOpacity(0.65)
                            : Colors.transparent),
                    child: Padding(
                      padding: settingNotifier.isSetBackgroundImage ==
                          true
                          ? const EdgeInsets.all(5.0)
                          : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                      child: Text(
                        CommonLanguages.convert(
                            lang:
                            settingNotifier.languageString ??
                                CommonLanguages
                                    .languageStringDefault(),
                            word: 'screen.title.subjects')
                            .toString(),
                        style: GoogleFonts.montserrat(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeDataCenter
                                .getFormFieldLabelColorStyle(
                                context)),
                      ),
                    ),
                  ),
                  Expanded(child: widget.subjectFoldersWidget),
                ],
              ),
              Column(
                children: [
                  Container(
                    margin: settingNotifier.isSetBackgroundImage ==
                        true
                        ? const EdgeInsets.fromLTRB(0, 2.0, 0, 2.0)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                            Radius.circular(12)),
                        color: settingNotifier.isSetBackgroundImage ==
                            true
                            ? Colors.white.withOpacity(0.65)
                            : Colors.transparent),
                    child: Padding(
                      padding: settingNotifier.isSetBackgroundImage ==
                          true
                          ? const EdgeInsets.all(5.0)
                          : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                      child: Text(
                        CommonLanguages.convert(
                            lang:
                            settingNotifier.languageString ??
                                CommonLanguages
                                    .languageStringDefault(),
                            word: 'screen.title.notes')
                            .toString(),
                        style: GoogleFonts.montserrat(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeDataCenter
                                .getFormFieldLabelColorStyle(
                                context)),
                      ),
                    ),
                  ),
                  Expanded(child: widget.notesWidget),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
