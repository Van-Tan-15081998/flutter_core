import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_add_screen.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../features/note/controllers/note_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum NavigationBarEnum {masterHome, masterSearch, masterAdd, masterDrawer}

class _HomeScreenState extends State<HomeScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  NavigationBarEnum _navigationIndex = NavigationBarEnum.masterHome;

  _onChangeNavigation(NavigationBarEnum navigationIndex) {
    setState(() {
      _navigationIndex = navigationIndex;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    NoteController controller = NoteController() ;
    controller.initData();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: const Color(0xff28a745),
          title: Text(
            widget.title,
            style: GoogleFonts.montserrat(
                fontStyle: FontStyle.italic, fontSize: 30),
          ),
        ),
        body: NoteListScreen(),
      bottomNavigationBar: CoreBottomNavigationBar(
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
                    coreStyle: _navigationIndex == NavigationBarEnum.masterHome ? CoreStyle.filled : CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_24,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(Icons.home),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: () {
                  _onChangeNavigation(NavigationBarEnum.masterSearch);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: _navigationIndex == NavigationBarEnum.masterSearch ? CoreStyle.filled : CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_24,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(Icons.search),
              ),
              const SizedBox(width: 5),
              CoreElevatedButton(
                onPressed: (){
                  _onChangeNavigation(NavigationBarEnum.masterAdd);

                  Get.to(const NoteAddScreen(actionMode: ActionModeEnum.create));
                  // showDialog<String>(
                  //     context: context,
                  //     builder: (BuildContext context) => const NoteAddScreen(actionMode: ActionModeEnum.create,)
                  // );
                  // Get.toNamed('/note-add');
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: _navigationIndex == NavigationBarEnum.masterAdd ? CoreStyle.filled : CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_24,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(Icons.add),
              ),
              const SizedBox(width: 5),
              const Spacer(),
              CoreElevatedButton(
                onPressed: () {
                  _onChangeNavigation(NavigationBarEnum.masterDrawer);
                },
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: _navigationIndex == NavigationBarEnum.masterDrawer ? CoreStyle.filled : CoreStyle.outlined,
                    coreColor: CoreColor.success,
                    coreRadius: CoreRadius.radius_24,
                    kitForegroundColorOption: Colors.black),
                child: const Icon(Icons.menu),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
