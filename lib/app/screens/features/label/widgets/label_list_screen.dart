import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../../library/common/styles/CommonStyles.dart';
import '../../../../library/enums/CommonEnums.dart';
import '../../../home/home_screen.dart';
import '../models/label_model.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/label_notifier.dart';
import 'functions/label_widget.dart';
import 'label_create_screen.dart';

class LabelListScreen extends StatefulWidget {
  const LabelListScreen({super.key});

  @override
  State<LabelListScreen> createState() => _LabelListScreenState();
}

class _LabelListScreenState extends State<LabelListScreen> {
  List<LabelModel> labels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF202124),
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
            child: CoreElevatedButton.icon(
              icon: const FaIcon(FontAwesomeIcons.house, size: 18.0),
              label: Text('Home', style: CommonStyles.buttonTextStyle),
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
                  coreColor: CoreColor.dark,
                  coreRadius: CoreRadius.radius_6,
                  kitBackgroundColorOption: Colors.white70,
                  kitForegroundColorOption: const Color(0xFF404040),
                  coreFixedSizeButton: CoreFixedSizeButton.medium_40),
            ),
          )
        ],
        backgroundColor: const Color(0xFF202124),
        title: Text(
          'Labels',
          style:
              GoogleFonts.montserrat( fontStyle: FontStyle.italic,
                  fontSize: 30,
                  color: const Color(0xFF404040),
                  fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF404040), // Set the color you desire
        ),
      ),
      body: ListView.builder(
          itemBuilder: (context, index) => LabelWidget(
                label: context.watch<LabelNotifier>().labels![index],
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
          itemCount: context.watch<LabelNotifier>().labels!.length),
      bottomNavigationBar: CoreBottomNavigationBar(
        backgroundColor: const Color(0xFF202124),
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
                onPressed: () {},
                coreButtonStyle: CoreButtonStyle.options(
                    coreStyle: CoreStyle.outlined,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LabelCreateScreen(
                            actionMode: ActionModeEnum.create)),
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
