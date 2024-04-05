import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_create_screen.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../core/state_management/dispatch_events/dispatch_listener_event.dart';
import '../../library/enums/CommonEnums.dart';
import '../features/label/providers/label_notifier.dart';
import '../features/label/widgets/label_list_screen.dart';
import '../features/note/databases/note_db_manager.dart';
import '../features/note/providers/note_notifier.dart';
import '../features/subjects/providers/subject_notifier.dart';
import '../features/subjects/widgets/subject_list_screen.dart';
import '../features/task/task_home_screen.dart';

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

  NavigationBarEnum _navigationIndex = NavigationBarEnum.masterHome;

  _onChangeNavigation(NavigationBarEnum navigationIndex) {
    setState(() {
      _navigationIndex = navigationIndex;
      _scaffoldKey.currentState!.openDrawer();
    });
  }

  void handleScreenChanged(int selectedScreen) {
    setState(() {
      screenIndex = selectedScreen;
    });
  }

  Widget statisticHomeScreen() {
    return SingleChildScrollView(
        child: Column(children: [
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
                          const Icon(Icons.note_alt_outlined, size: 26.0,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width - 125.0,
                              child: const Text('Notes', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),)),
                          CoreElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const NoteListScreen(noteConditionModel: null,)),
                              );
                            },
                            coreButtonStyle: CoreButtonStyle.dark(
                                kitRadius: 6.0),
                            child: const Text('View'),
                          ),
                        ]),
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
                      child:  Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              const Icon(Icons.now_widgets_rounded, color: Colors.black45),
                              const SizedBox(width: 10.0,),
                              const Text('Total:',style: TextStyle(fontSize: 16.0),),
                              Text(context.watch<NoteNotifier>().countAllNotes.toString(), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ],
          )),
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
                              const Icon(Icons.task_outlined, size: 26.0,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 125.0,
                                  child: const Text('Tasks', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),)),
                              CoreElevatedButton(
                                onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const TaskHomeScreen()),
                                );
                                },
                                coreButtonStyle: CoreButtonStyle.dark(
                                    kitRadius: 6.0),
                                child: const Text('View'),
                              ),
                            ]),
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
                          child: const Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(Icons.now_widgets_rounded, color: Colors.black45),
                                  SizedBox(width: 10.0,),
                                  Text('Total:',style: TextStyle(fontSize: 16.0),),
                                  Text('100', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              )),
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
                              const Icon(Icons.palette_outlined, size: 26.0,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 125.0,
                                  child: const Text('Subjects', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),)),
                              CoreElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SubjectListScreen(subjectConditionModel: null,)),
                                  );
                                },
                                coreButtonStyle: CoreButtonStyle.dark(
                                    kitRadius: 6.0),
                                child: const Text('View'),
                              ),
                            ]),
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
                                  const Icon(Icons.now_widgets_rounded, color: Colors.black45),
                                  const SizedBox(width: 10.0,),
                                  const Text('Total:',style: TextStyle(fontSize: 16.0),),
                                  Text(context.watch<SubjectNotifier>().countAllSubjects.toString(), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              )),
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
                              const Icon(Icons.label_important_outline, size: 26.0,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 125.0,
                                  child: const Text('Labels', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),)),
                              CoreElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LabelListScreen()),
                                  );
                                },
                                coreButtonStyle: CoreButtonStyle.dark(
                                    kitRadius: 6.0),
                                child: const Text('View'),
                              ),
                            ]),
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
                                  const Icon(Icons.now_widgets_rounded, color: Colors.black45),
                                  const SizedBox(width: 10.0,),
                                  const Text('Total:',style: TextStyle(fontSize: 16.0),),
                                  Text(context.watch<LabelNotifier>().countAllLabels.toString(), style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              )),
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
                              const Icon(Icons.content_paste_rounded, size: 26.0,),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width - 125.0,
                                  child: const Text('Templates', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),)),
                              CoreElevatedButton(
                                onPressed: () {
                                  Get.to(const NoteListScreen(noteConditionModel: null));
                                },
                                coreButtonStyle: CoreButtonStyle.dark(
                                    kitRadius: 6.0),
                                child: const Text('View'),
                              ),
                            ]),
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
                          child: const Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(Icons.now_widgets_rounded, color: Colors.black45),
                                  SizedBox(width: 10.0,),
                                  Text('Total:',style: TextStyle(fontSize: 16.0),),
                                  Text('100', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),),
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                ],
              )),
    ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // onGetCountAll();
  }

  onGetCountAll() async {
    countAllNotes = await NoteDatabaseManager.onCountAll();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF202124),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202124),
        title: Text(
          widget.title,
          style:
              GoogleFonts.montserrat(
                  fontStyle: FontStyle.italic,
                  fontSize: 30,
                  color: const Color(0xFF404040),
                  fontWeight: FontWeight.w600
              ),
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
                color: Color(0xff28a745),
              ),
              child: Text('Hi Notes',
                style: GoogleFonts.montserrat(
                    fontStyle: FontStyle.italic,
                    fontSize: 30,
                    color: const Color(0xFF404040),
                    fontWeight: FontWeight.bold)),
            ),
            ...destinations.map(
              (ExampleDestination destination) {
                return ListTile(
                  title: Text(destination.label),
                  leading: Container(child: destination.icon),
                  selected: screenIndex == destination.id,
                  onTap: () {
                    handleScreenChanged(destination.id);
                    Navigator.pop(context);

                    if (destination.screen != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => destination.screen!),
                      );
                    }
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 16, 28, 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Divider(color: Colors.black45),
                  CoreElevatedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.xmark, size: 18.0),
                    label: const Text('Close menu'),
                    onPressed: () {
                      _scaffoldKey.currentState!.closeDrawer();
                    },
                    coreButtonStyle: CoreButtonStyle.options(
                        coreStyle: CoreStyle.outlined,
                        coreColor: CoreColor.success,
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
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CoreElevatedButton(
                onPressed: () {
                  _onChangeNavigation(NavigationBarEnum.masterHome);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: _navigationIndex == NavigationBarEnum.masterHome
                        ? CoreStyle.filled
                        : CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.home,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {
                  _onChangeNavigation(NavigationBarEnum.masterSearch);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle:
                        _navigationIndex == NavigationBarEnum.masterSearch
                            ? CoreStyle.filled
                            : CoreStyle.outlined,
                    coreColor: CoreColor.dark,
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
                  _onChangeNavigation(NavigationBarEnum.masterAdd);

                  Get.to(
                      const NoteCreateScreen(actionMode: ActionModeEnum.create));
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: _navigationIndex == NavigationBarEnum.masterAdd
                        ? CoreStyle.filled
                        : CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.add,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {
                  DispatchListenerEvent.dispatch(
                      'DISPATCH_GET_RELOAD_NOTE_LIST', null);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: _navigationIndex == NavigationBarEnum.masterAdd
                        ? CoreStyle.filled
                        : CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.refresh,
                  size: 25.0,
                ),
              ),
              const SizedBox(width: 5),
              const Spacer(),
              CoreElevatedButton(
                onPressed: () {
                  _onChangeNavigation(NavigationBarEnum.masterDrawer);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle:
                        _navigationIndex == NavigationBarEnum.masterDrawer
                            ? CoreStyle.filled
                            : CoreStyle.outlined,
                    coreColor: CoreColor.dark,
                    coreRadius: CoreRadius.radius_6,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(
                  Icons.menu,
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

class ExampleDestination {
  const ExampleDestination(
      this.id, this.label, this.icon, this.selectedIcon, this.screen);

  final int id;
  final String label;
  final Widget icon;
  final Widget selectedIcon;
  final Widget? screen;
}

const List<ExampleDestination> destinations = <ExampleDestination>[
  ExampleDestination(
      1, 'Home', Icon(Icons.home_outlined), Icon(Icons.home_outlined), null),
  ExampleDestination(2, 'Notes', Icon(Icons.note_alt_outlined),
      Icon(Icons.note_alt_outlined), NoteListScreen(noteConditionModel: null)),
  ExampleDestination(
      3, 'Tasks', Icon(Icons.task_outlined), Icon(Icons.task_outlined), null),
  ExampleDestination(4, 'Labels', Icon(Icons.label_important_outline),
      Icon(Icons.label_important_outline), LabelListScreen()),
  ExampleDestination(5, 'Template', Icon(Icons.content_paste_rounded),
      Icon(Icons.content_paste_rounded), null),
];
