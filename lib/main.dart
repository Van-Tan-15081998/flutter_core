import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/home/home_screen.dart';
import 'package:flutter_core_v3/core/components/actions/common_buttons/CoreButtonStyle.dart';
import 'package:flutter_core_v3/core/components/containment/bottom_sheets/CoreModalBottomSheet.dart';
import 'package:flutter_core_v3/core/components/containment/bottom_sheets/CoreStandardBottomSheet.dart';
import 'package:flutter_core_v3/core/components/containment/dialogs/CoreBasicDialog.dart';
import 'package:flutter_core_v3/core/components/containment/dialogs/CoreConfirmDialog.dart';
import 'package:flutter_core_v3/core/components/containment/dialogs/CoreFullScreenDialog.dart';
import 'package:flutter_core_v3/core/components/form/CoreDisableFormField.dart';
import 'package:flutter_core_v3/core/components/form/CoreEmailFormField.dart';
import 'package:flutter_core_v3/core/components/form/CoreFormStyle.dart';
import 'package:flutter_core_v3/core/components/form/CoreMultilineFormField.dart';
import 'package:flutter_core_v3/core/components/form/CoreNumberFormField.dart';
import 'package:flutter_core_v3/core/components/form/CorePasswordFormField.dart';
import 'package:flutter_core_v3/core/components/form/CoreTextFormField.dart';
import 'package:flutter_core_v3/core/components/form/CoreTextRowFormField.dart';
import 'package:flutter_core_v3/core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import 'package:provider/provider.dart';

import 'app/library/enums/CommonEnums.dart';
import 'app/screens/features/demo/expandable/expandable_home_screen.dart';
import 'app/screens/features/demo/flutter_quill/flutter_quill_home_screen.dart';
import 'app/screens/features/demo/get/GetHome.dart';
import 'app/screens/features/demo/get/example/bindings/SampleBind.dart';
import 'app/screens/features/demo/get/example/models/MyTranslations.dart';
import 'app/screens/features/demo/get/example/models/SizeTransitions.dart';
import 'app/screens/features/demo/get/example/views/First.dart';
import 'app/screens/features/demo/get/example/views/Second.dart';
import 'app/screens/features/demo/get/example/views/Third.dart';
import 'app/screens/features/demo/provider/provider_home_screen.dart';
import 'app/screens/features/note/bindings/note_binding.dart';
import 'app/screens/features/note/note_add_screen.dart';
import 'app/screens/features/note/note_list_screen.dart';
import 'app/services/database/demo/screens/notes_screen.dart';
import 'core/components/actions/common_buttons/CoreElevatedButton.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:get/get.dart';

import 'main_test.dart';

// void main() {
//   runApp(MaterialApp(
//       theme: ThemeData(
//           colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//           useMaterial3: true,
//           inputDecorationTheme: CoreFormStyle().theme()),
//       debugShowCheckedModeBanner: false,
//       // home: MyAppTest()));
//       home: const HomeScreen(title: 'Hi Task')));
//
//   // runApp(MyApp1());
// }

void main() {
  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
      ],
      child: const MyAppProvider(),
    ),
  );
}

class MyApp1 extends StatelessWidget {
  const MyApp1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Database demo app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const FlutterQuillHomeScreen(),
      home: ExpandableHomeScreen(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          inputDecorationTheme: CoreFormStyle().theme()),
      // home: const MyHomePage(title: 'Hi Tasks'),
      home: const HomeScreen(title: 'Hi Tasks'),
      debugShowCheckedModeBanner: false,
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   ScrollController _scrollController = ScrollController();
//   FocusNode _focusNode = FocusNode();
//   void _scrollToFormField() {
//     // Find the position of the target TextFormField
//     final RenderBox renderBox =
//         _focusNode.context!.findRenderObject() as RenderBox;
//     final double offset = renderBox.localToGlobal(Offset.zero).dy;
//
//     // Scroll to the TextFormField
//     _scrollController.position.animateTo(
//       offset,
//       duration: Duration(milliseconds: 500),
//       curve: Curves.ease,
//     );
//   }
//
//   Future<bool> confirmFunction() async {
//     bool result = false;
//     await showDialog<bool>(
//         context: context,
//         builder: (BuildContext context) => CoreBasicDialog(
//               child: CoreConfirmDialog(
//                 initialData: false,
//                 onChanged: (value) => result = value,
//               ),
//             ));
//     if (!result) {
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   int _selectedIndex = 0;
//   static const TextStyle optionStyle =
//       TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
//   static const List<Widget> _widgetOptions = <Widget>[
//     Text(
//       'Index 0: Home',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 1: Business',
//       style: optionStyle,
//     ),
//     Text(
//       'Index 2: School',
//       style: optionStyle,
//     ),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//
//   final _formKey = GlobalKey<FormState>();
//
//   String inputData = '';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         backgroundColor: const Color(0xff28a745),
//         title: Text(
//           widget.title,
//           style:
//               GoogleFonts.montserrat(fontStyle: FontStyle.italic, fontSize: 30),
//         ),
//       ),
//       body: Center(
//         child: ListView(children: [
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               CoreElevatedButton(
//                 child: const Text('On Press Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.styleStandard(),
//               ),
//               CoreElevatedButton.icon(
//                 icon: Icon(Icons.icecream_rounded),
//                 label: const Text('Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.success(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.turtles(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.stormi(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.slate(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Primary'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.primary(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Secondary'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.secondary(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Success'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.success(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Danger'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.danger(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Warning'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.warning(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Info'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.info(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Light'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.light(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Dark'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.dark(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('On Press Link'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.link(),
//               ),
//               CoreElevatedButton(
//                 child: const Text('Option'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.elevated,
//                     coreColor: CoreColor.warning,
//                     kitForegroundColorOption: Colors.red),
//               ),
//               CoreElevatedButton(
//                 child: const Text('Option'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.outlined,
//                     coreColor: CoreColor.warning,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton(
//                 child: const Text('Option'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filledTonal,
//                     coreColor: CoreColor.warning,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton(
//                 child: const Text('Option'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_2,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton(
//                 child: const Text('Option'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_6,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton(
//                 child: const Text('Option'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton.icon(
//                 icon: Icon(Icons.icecream_rounded),
//                 label: const Text('Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton(
//                 child: Icon(Icons.add_a_photo),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton(
//                 child: Icon(Icons.add),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_6,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               CoreElevatedButton.icon(
//                 icon: Icon(Icons.icecream_rounded),
//                 label: const Text('Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_2,
//                     kitForegroundColorOption: Colors.black,
//                     coreFixedSizeButton: CoreFixedSizeButton.small_32),
//               ),
//               CoreElevatedButton.icon(
//                 icon: Icon(Icons.icecream_rounded),
//                 label: const Text('Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_6,
//                     kitForegroundColorOption: Colors.black,
//                     coreFixedSizeButton: CoreFixedSizeButton.medium_40),
//               ),
//               CoreElevatedButton.icon(
//                 icon: Icon(Icons.icecream_rounded),
//                 label: const Text('Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_6,
//                     kitForegroundColorOption: Colors.black,
//                     coreFixedSizeButton: CoreFixedSizeButton.medium_48),
//               ),
//               CoreElevatedButton.icon(
//                 icon: Icon(Icons.icecream_rounded),
//                 label: const Text('Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_6,
//                     kitForegroundColorOption: Colors.black,
//                     coreFixedSizeButton: CoreFixedSizeButton.large_52),
//               ),
//               CoreElevatedButton.icon(
//                 icon: Icon(Icons.icecream_rounded),
//                 label: const Text('Green'),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.warning,
//                     coreRadius: CoreRadius.radius_6,
//                     kitForegroundColorOption: Colors.black,
//                     coreFixedSizeButton: CoreFixedSizeButton.large_56),
//               ),
//             ],
//           ),
//         ]),
//       ),
//       bottomNavigationBar: CoreBottomNavigationBar(
//         child: IconTheme(
//           data: const IconThemeData(color: Colors.white),
//           child: Row(
//             // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: <Widget>[
//               CoreElevatedButton(
//                 child: Icon(Icons.home),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.filled,
//                     coreColor: CoreColor.success,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               SizedBox(width: 5),
//               CoreElevatedButton(
//                 child: Icon(Icons.search),
//                 onPressed: () {},
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.outlined,
//                     coreColor: CoreColor.success,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               SizedBox(width: 5),
//               CoreElevatedButton(
//                 child: Icon(Icons.add),
//                 onPressed: () => showDialog<String>(
//                   context: context,
//                   builder: (BuildContext context) => CoreFullScreenDialog(
//                     title: 'AA',
//                     isConfirmToClose: true,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Form(
//                         onWillPop: () => confirmFunction(),
//                         child: ListView(
//                           controller: _scrollController,
//                           // mainAxisSize: MainAxisSize.max,
//                           // mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             CorePasswordFormField(),
//                             CoreNumberFormField(),
//                             CoreEmailFormField(),
//                             CoreDisableFormField(),
//                             CoreMultilineFormField(),
//                             CoreTextRowFormField(),
//                             CoreTextFormField(
//                               focusNode: _focusNode,
//                               initialData: inputData,
//                               onChanged: (value) => {
//                                 setState(() {
//                                   inputData =
//                                       value; // Cập nhật dữ liệu từ custom component
//
//                                   print(inputData);
//                                 })
//                               },
//                               controller:
//                                   TextEditingController(text: inputData),
//                             ),
//                             CoreMultilineFormField(),
//                             CoreTextRowFormField(),
//                             const SizedBox(height: 15),
//                             TextButton(
//                               onPressed: () {
//                                 // Navigator.pop(context);
//                                 _scrollController.animateTo(
//                                   0, // Điểm đầu tiên (đầu danh sách)
//                                   duration: Duration(
//                                       milliseconds: 500), // Thời gian cuộn
//                                   curve: Curves.ease, // Đường cong cuộn
//                                 );
//                               },
//                               child: const Text('Close'),
//                             ),
//                             SizedBox(
//                               height: 200,
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.outlined,
//                     coreColor: CoreColor.success,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               SizedBox(width: 5),
//               CoreElevatedButton(
//                 child: Icon(Icons.add),
//                 onPressed: () => showModalBottomSheet<void>(
//                     context: context,
//                     isScrollControlled: true,
//                     builder: (BuildContext context) {
//                       return CoreStandardBottomSheet(
//                         child: CoreTextFormField(
//                           focusNode: _focusNode,
//                           initialData: inputData,
//                           onChanged: (value) => {
//                             setState(() {
//                               inputData =
//                                   value; // Cập nhật dữ liệu từ custom component
//
//                               print(inputData);
//                             })
//                           },
//                           controller: TextEditingController(text: inputData),
//                         ),
//                       );
//                     }),
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.outlined,
//                     coreColor: CoreColor.success,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//               const Spacer(),
//               CoreElevatedButton(
//                 child: Icon(Icons.menu),
//                 onPressed: () => _scaffoldKey.currentState?.openDrawer(),
//                 coreButtonStyle: CoreButtonStyle.options(
//                     coreStyle: CoreStyle.outlined,
//                     coreColor: CoreColor.success,
//                     coreRadius: CoreRadius.radius_24,
//                     kitForegroundColorOption: Colors.black),
//               ),
//             ],
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         // Add a ListView to the drawer. This ensures the user can scroll
//         // through the options in the drawer if there isn't enough vertical
//         // space to fit everything.
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//               ),
//               child: Text('Drawer Header'),
//             ),
//             ListTile(
//               title: const Text('Home'),
//               selected: _selectedIndex == 0,
//               onTap: () {
//                 // Update the state of the app
//                 _onItemTapped(0);
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('Business'),
//               selected: _selectedIndex == 1,
//               onTap: () {
//                 // Update the state of the app
//                 _onItemTapped(1);
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               title: const Text('School'),
//               selected: _selectedIndex == 2,
//               onTap: () {
//                 // Update the state of the app
//                 _onItemTapped(2);
//                 // Then close the drawer
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
