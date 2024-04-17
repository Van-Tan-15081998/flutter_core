import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/screens/features/label/providers/label_notifier.dart';
import 'app/screens/features/note/providers/note_notifier.dart';
import 'app/screens/features/subjects/providers/subject_notifier.dart';
import 'app/screens/home/home_screen.dart';
import 'app/screens/setting/providers/setting_notifier.dart';
import 'core/components/form/CoreFormStyle.dart';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteNotifier()),
        ChangeNotifierProvider(create: (_) => LabelNotifier()),
        ChangeNotifierProvider(create: (_) => SubjectNotifier()),
        ChangeNotifierProvider(create: (_) => SettingNotifier()),
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
