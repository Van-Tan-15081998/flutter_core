import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_create_screen.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../core/components/notifications/CoreNotification.dart';
import '../../library/common/styles/CommonStyles.dart';
import '../../library/enums/CommonEnums.dart';
import '../features/label/providers/label_notifier.dart';
import '../features/label/widgets/label_list_screen.dart';
import '../features/note/databases/note_db_manager.dart';
import '../features/note/providers/note_notifier.dart';
import '../features/subjects/providers/subject_notifier.dart';
import '../features/subjects/widgets/subject_list_screen.dart';
import '../setting/providers/setting_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum NavigationBarEnum { masterHome, masterSearch, masterAdd, masterDrawer }

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int screenIndex = 0;

  int countAllNotes = 0;
  int countAllLabels = 0;
  int countAllTasks = 0;

  bool isSetColorAccordingSubjectColor = false;
  bool isActiveSound = false;
  bool isExpandedNoteContent = false;
  bool isExpandedSubjectActions = false;

  Widget statisticHomeScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Đây là giá trị bo góc ở đây
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  // height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            Icons.note_alt_outlined,
                            size: 26.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 125.0,
                            child: const Text(
                              'Notes',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Tooltip(
                            message: 'View',
                            child: CoreElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const NoteListScreen(
                                            noteConditionModel: null,
                                          )),
                                );
                              },
                              coreButtonStyle:
                                  CoreButtonStyle.dark(kitRadius: 6.0),
                              child: const Text('View'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        boxShadow: [],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.now_widgets_rounded,
                                  color: Colors.black45),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text(
                                'Total:',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                context
                                    .watch<NoteNotifier>()
                                    .countAllNotes
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ///
          Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Đây là giá trị bo góc ở đây
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  // height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            Icons.palette_outlined,
                            size: 26.0,
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 125.0,
                              child: const Text(
                                'Subjects',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500),
                              )),
                          Tooltip(
                            message: 'View',
                            child: CoreElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SubjectListScreen(
                                      subjectConditionModel: null,
                                    ),
                                  ),
                                );
                              },
                              coreButtonStyle:
                                  CoreButtonStyle.dark(kitRadius: 6.0),
                              child: const Text('View'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        boxShadow: [],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.now_widgets_rounded,
                                  color: Colors.black45),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text(
                                'Total:',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                context
                                    .watch<SubjectNotifier>()
                                    .countAllSubjects
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ///
          Card(
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(5.0), // Đây là giá trị bo góc ở đây
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  // height: 150,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            Icons.label_important_outline,
                            size: 26.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 125.0,
                            child: const Text(
                              'Labels',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Tooltip(
                            message: 'View',
                            child: CoreElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LabelListScreen(
                                            labelConditionModel: null,
                                          )),
                                );
                              },
                              coreButtonStyle:
                                  CoreButtonStyle.dark(kitRadius: 6.0),
                              child: const Text('View'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: const BoxDecoration(
                        shape: BoxShape.rectangle,
                        boxShadow: [],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.now_widgets_rounded,
                                  color: Colors.black45),
                              const SizedBox(
                                width: 10.0,
                              ),
                              const Text(
                                'Total:',
                                style: TextStyle(fontSize: 16.0),
                              ),
                              Text(
                                context
                                    .watch<LabelNotifier>()
                                    .countAllLabels
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  onGetCountAll() async {
    countAllNotes = await NoteDatabaseManager.onCountAll();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);
    isSetColorAccordingSubjectColor =
        settingNotifier.isSetColorAccordingSubjectColor ?? false;
    isActiveSound = settingNotifier.isActiveSound ?? false;
    isExpandedNoteContent = settingNotifier.isExpandedNoteContent ?? false;
    isExpandedSubjectActions = settingNotifier.isExpandedSubjectActions ?? false;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF202124),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202124),
        title: Text(
          widget.title,
          style: GoogleFonts.montserrat(
              fontStyle: FontStyle.italic,
              fontSize: 30,
              color: const Color(0xFF404040),
              fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF404040), // Set the color you desire
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF202124),
              ),
              child: Text('Hi Notes',
                  style: GoogleFonts.montserrat(
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      color: const Color(0xFF404040),
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 16, 25, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFF202124),
                        borderRadius: BorderRadius.circular(4.0)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Settings',
                              style: GoogleFonts.montserrat(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18,
                                  color: const Color(0xFF404040),
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 5, 0, 0),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text(
                                  'Set note background color according to subject color',
                                  style: CommonStyles.settingLabelTextStyle),
                            ),
                            Checkbox(
                              checkColor: Colors.white,
                              value: isSetColorAccordingSubjectColor,
                              onChanged: (bool? value) {
                                settingNotifier
                                    .setIsSetColorAccordingSubjectColor(value!)
                                    .then((success) {
                                  if (success) {
                                    setState(() {
                                      isSetColorAccordingSubjectColor = value;
                                    });

                                    CoreNotification.show(
                                        context,
                                        CoreNotificationStatus.success,
                                        CoreNotificationAction.update,
                                        'Setting');
                                  }
                                });
                              },
                            ),
                          ]);
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 5, 0, 0),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text('Note content expanded',
                                  style: CommonStyles.settingLabelTextStyle),
                            ),
                            Checkbox(
                              checkColor: Colors.white,
                              value: isExpandedNoteContent,
                              onChanged: (bool? value) {
                                settingNotifier
                                    .setIsExpandedNoteContent(value!)
                                    .then((success) {
                                  if (success) {
                                    setState(() {
                                      isExpandedNoteContent = value;
                                    });

                                    CoreNotification.show(
                                        context,
                                        CoreNotificationStatus.success,
                                        CoreNotificationAction.update,
                                        'Setting');
                                  }
                                });
                              },
                            ),
                          ]);
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Text('Subject actions expanded',
                                      style: CommonStyles.settingLabelTextStyle),
                                ),
                                Checkbox(
                                  checkColor: Colors.white,
                                  value: isExpandedSubjectActions,
                                  onChanged: (bool? value) {
                                    settingNotifier
                                        .setIsExpandedSubjectActions(value!)
                                        .then((success) {
                                      if (success) {
                                        setState(() {
                                          isExpandedSubjectActions = value;
                                        });

                                        CoreNotification.show(
                                            context,
                                            CoreNotificationStatus.success,
                                            CoreNotificationAction.update,
                                            'Setting');
                                      }
                                    });
                                  },
                                ),
                              ]);
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text('Sounds',
                                  style: CommonStyles.settingLabelTextStyle),
                            ),
                            Checkbox(
                              checkColor: Colors.white,
                              value: isActiveSound,
                              onChanged: (bool? value) {
                                settingNotifier
                                    .setIsActiveSound(value!)
                                    .then((success) {
                                  if (success) {
                                    setState(() {
                                      isActiveSound = value;
                                    });

                                    CoreNotification.show(
                                        context,
                                        CoreNotificationStatus.success,
                                        CoreNotificationAction.update,
                                        'Setting');
                                  }
                                });
                              },
                            ),
                          ]);
                    }),
                  ),
                  const Divider(color: Colors.black45),
                  CoreElevatedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.xmark, size: 18.0),
                    label: const Text('Close menu'),
                    onPressed: () {
                      _scaffoldKey.currentState!.closeDrawer();
                    },
                    coreButtonStyle: CoreButtonStyle.options(
                        coreStyle: CoreStyle.outlined,
                        coreColor: CoreColor.dark,
                        coreRadius: CoreRadius.radius_6,
                        kitForegroundColorOption: Colors.black,
                        coreFixedSizeButton: CoreFixedSizeButton.medium_40),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: statisticHomeScreen(),
      bottomNavigationBar: CoreBottomNavigationBar(
        backgroundColor: const Color(0xFF202124),
        child: IconTheme(
          data: const IconThemeData(color: Colors.white),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CoreElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NoteCreateScreen(
                            subject: null, actionMode: ActionModeEnum.create)),
                  );
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
                    coreColor: CoreColor.dark,
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
