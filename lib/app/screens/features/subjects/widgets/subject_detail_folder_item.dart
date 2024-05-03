import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../library/common/languages/CommonLanguages.dart';
import '../../../../library/common/themes/ThemeDataCenter.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../setting/providers/setting_notifier.dart';
import '../models/subject_model.dart';

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
                    margin: settingNotifier.isSetBackgroundImage == true
                        ? const EdgeInsets.fromLTRB(0, 2.0, 0, 2.0)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: settingNotifier.isSetBackgroundImage == true
                            ? Colors.white.withOpacity(0.65)
                            : Colors.transparent),
                    child: Padding(
                      padding: settingNotifier.isSetBackgroundImage == true
                          ? const EdgeInsets.all(5.0)
                          : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                      child: Text(
                        CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'screen.title.subjects')
                            .toString(),
                        style: GoogleFonts.montserrat(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeDataCenter.getFormFieldLabelColorStyle(
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
                    margin: settingNotifier.isSetBackgroundImage == true
                        ? const EdgeInsets.fromLTRB(0, 2.0, 0, 2.0)
                        : const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                        color: settingNotifier.isSetBackgroundImage == true
                            ? Colors.white.withOpacity(0.65)
                            : Colors.transparent),
                    child: Padding(
                      padding: settingNotifier.isSetBackgroundImage == true
                          ? const EdgeInsets.all(5.0)
                          : const EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                      child: Text(
                        CommonLanguages.convert(
                                lang: settingNotifier.languageString ??
                                    CommonLanguages.languageStringDefault(),
                                word: 'screen.title.notes')
                            .toString(),
                        style: GoogleFonts.montserrat(
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ThemeDataCenter.getFormFieldLabelColorStyle(
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
