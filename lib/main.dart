import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'app/screens/features/label/providers/label_notifier.dart';
import 'app/screens/features/note/providers/note_notifier.dart';
import 'app/screens/features/subjects/providers/subject_notifier.dart';
import 'app/screens/features/template/providers/template_notifier.dart';
import 'app/screens/home/home_screen.dart';
import 'app/screens/setting/providers/setting_notifier.dart';
import 'core/components/form/CoreFormStyle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration =
      RequestConfiguration(testDeviceIds: ["C21014BDE4C91BDB5A72F94C1582DEC7"]);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteNotifier()),
        ChangeNotifierProvider(create: (_) => LabelNotifier()),
        ChangeNotifierProvider(create: (_) => SubjectNotifier()),
        ChangeNotifierProvider(create: (_) => SettingNotifier()),
        ChangeNotifierProvider(create: (_) => TemplateNotifier()),
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
