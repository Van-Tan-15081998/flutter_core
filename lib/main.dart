import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'app/library/common/utils/CommonAudioBackground.dart';
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

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => NoteNotifier()),
    ChangeNotifierProvider(create: (_) => LabelNotifier()),
    ChangeNotifierProvider(create: (_) => SubjectNotifier()),
    ChangeNotifierProvider(create: (_) => SettingNotifier()),
    ChangeNotifierProvider(create: (_) => TemplateNotifier()),
  ], child: const RootScreen()));
  // runApp(const  MyScrollPagination());
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _UserManualScreenState();
}

class _UserManualScreenState extends State<RootScreen>
    with WidgetsBindingObserver {
  CommonAudioBackground commonAudioBackground = CommonAudioBackground();
  String playingBackgroundMusicSourceString = '';
  String playingBackgroundMusicMark = '';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      commonAudioBackground.pause();
    } else {
      commonAudioBackground.resume();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    commonAudioBackground.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);
    playingBackgroundMusicSourceString =
        settingNotifier.playingBackgroundMusicSourceString ?? '';

    if (playingBackgroundMusicSourceString != playingBackgroundMusicMark) {
      if (CommonAudioBackground.backgroundMusicList()
          .contains(playingBackgroundMusicSourceString)) {
        commonAudioBackground.play(
            url: playingBackgroundMusicSourceString, isLoop: true);
      } else if (playingBackgroundMusicSourceString == 'TURNOFF') {
        commonAudioBackground.stop();
      } else if (playingBackgroundMusicSourceString == 'ALL') {
        commonAudioBackground.playList();
      }
    }

    playingBackgroundMusicMark = playingBackgroundMusicSourceString;

    return MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            inputDecorationTheme: CoreFormStyle().theme()),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(title: 'Hi Notes'));
  }
}
