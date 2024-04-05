import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/home/home_screen.dart';
import 'package:flutter_core_v3/core/components/form/CoreFormStyle.dart';
import 'package:provider/provider.dart';
import 'app/screens/features/demo/expandable/expandable_home_screen.dart';
import 'app/screens/features/demo/infinite_scroll_pagination/scroll_pagination.dart';
import 'app/screens/features/label/providers/label_notifier.dart';
import 'app/screens/features/note/providers/note_notifier.dart';
import 'app/screens/features/subjects/providers/subject_notifier.dart';
import 'app/screens/features/task/providers/task_notifier.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskNotifier()),
        ChangeNotifierProvider(create: (_) => NoteNotifier()),
        ChangeNotifierProvider(create: (_) => LabelNotifier()),
        ChangeNotifierProvider(create: (_) => SubjectNotifier()),
      ],
      child: MaterialApp(
          theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              inputDecorationTheme: CoreFormStyle().theme()),
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(title: 'Hi Notes'))));
  // runApp(const  MyScrollPagination());
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
