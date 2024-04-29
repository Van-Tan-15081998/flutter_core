import 'package:animate_do/animate_do.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_create_screen.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../core/components/notifications/CoreNotification.dart';
import '../../library/common/dimensions/CommonDimensions.dart';
import '../../library/common/languages/CommonLanguages.dart';
import '../../library/common/styles/CommonStyles.dart';
import '../../library/common/themes/ThemeDataCenter.dart';
import '../../library/enums/CommonEnums.dart';
import '../features/label/providers/label_notifier.dart';
import '../features/label/widgets/label_list_screen.dart';
import '../features/note/databases/note_db_manager.dart';
import '../features/note/providers/note_notifier.dart';
import '../features/subjects/providers/subject_notifier.dart';
import '../features/subjects/widgets/subject_list_screen.dart';
import '../features/template/providers/template_notifier.dart';
import '../features/template/template_list_screen.dart';
import '../setting/providers/setting_notifier.dart';
import '../setting/setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum NavigationBarEnum { masterHome, masterSearch, masterAdd, masterDrawer }

class _HomeScreenState extends State<HomeScreen> {
  late BannerAd bannerAd;
  bool isAdLoaded = false;
  initBannerAd() {
    bannerAd = BannerAd(
        size: AdSize.banner,
        // adUnitId: "ca-app-pub-7127345763306561/2981583992",
        adUnitId: 'ca-app-pub-3940256099942544/9214589741',
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        }),
        request: const AdRequest());

    bannerAd.load();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int countAllNotes = 0;
  int countAllLabels = 0;
  int countAllTasks = 0;

  Widget _buildAd() {
    if (isAdLoaded) {
      return SizedBox(
        height: bannerAd.size.height.toDouble(),
        width: bannerAd.size.width.toDouble(),
        child: AdWidget(
          ad: bannerAd,
        ),
      );
    }
    return Container(
      height: 100,
      width: 200,
      color: Colors.yellow,
    );
  }

  Widget _buildAdB(BuildContext context, SettingNotifier settingNotifier) {
    if (isAdLoaded) {
      return FadeIn(
        duration: const Duration(milliseconds: 200),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
          child: Card(
            shadowColor: const Color(0xff1f1f1f),
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color:
                      ThemeDataCenter.getTemplateBorderCardColorStyle(context),
                  width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                SizedBox(
                  // height: 150,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeDataCenter.getTopBannerCardBackgroundColor(
                          context),
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Icon(
                            Icons.ad_units_rounded,
                            size: 26.0,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width - 125.0,
                            child: Text(
                              CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'screen.title.advertisements'),
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Tooltip(
                            message: 'Hide',
                            child: CoreElevatedButton(
                              onPressed: () {},
                              coreButtonStyle:
                                  ThemeDataCenter.getViewButtonStyle(context),
                              child: const Text('Hide'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: bannerAd.size.height.toDouble(),
                          width: bannerAd.size.width.toDouble(),
                          child: AdWidget(
                            ad: bannerAd,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildStatisticHomeScreen(
      BuildContext context, SettingNotifier settingNotifier) {
    return Column(
      children: [
        settingNotifier.isSetBackgroundImage == true
            ? SizedBox(height: CommonDimensions.scaffoldAppBarHeight(context))
            : Container(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                  child: Card(
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: ThemeDataCenter.getNoteBorderCardColorStyle(
                                context),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          // height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeDataCenter
                                  .getTopBannerCardBackgroundColor(context),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.note_alt_outlined,
                                    size: 26.0,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        125.0,
                                    child: Text(
                                      CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'screen.title.notes'),
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'View',
                                    child: CoreElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const NoteListScreen(
                                                    noteConditionModel: null,
                                                    isOpenSubjectsForFilter:
                                                        null,
                                                    redirectFrom: null,
                                                  )),
                                        );
                                      },
                                      coreButtonStyle:
                                          ThemeDataCenter.getViewButtonStyle(
                                              context),
                                      child: Text(CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'button.title.open')),
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
                              decoration: BoxDecoration(
                                color: ThemeDataCenter
                                    .getBottomBannerCardBackgroundColor(
                                        context),
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
                                      Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word: 'card.title.total'),
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(width: 5.0),
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
                ),

                ///
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                  child: Card(
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color:
                                ThemeDataCenter.getSubjectBorderCardColorStyle(
                                    context),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          // height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeDataCenter
                                  .getTopBannerCardBackgroundColor(context),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.palette_outlined,
                                    size: 26.0,
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width -
                                          125.0,
                                      child: Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word: 'screen.title.subjects'),
                                        style: const TextStyle(
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
                                            builder: (context) =>
                                                const SubjectListScreen(
                                              subjectConditionModel: null,
                                              redirectFrom: null,
                                            ),
                                          ),
                                        );
                                      },
                                      coreButtonStyle:
                                          ThemeDataCenter.getViewButtonStyle(
                                              context),
                                      child: Text(CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'button.title.open')),
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
                              decoration: BoxDecoration(
                                color: ThemeDataCenter
                                    .getBottomBannerCardBackgroundColor(
                                        context),
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
                                      Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word: 'card.title.total'),
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(width: 5.0),
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
                ),

                ///
                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                  child: Card(
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: ThemeDataCenter.getLabelBorderCardColorStyle(
                                context),
                            width: 1.0),
                        borderRadius: BorderRadius.circular(5.0)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          // height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeDataCenter
                                  .getTopBannerCardBackgroundColor(context),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.label_important_outline,
                                    size: 26.0,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        125.0,
                                    child: Text(
                                      CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'screen.title.labels'),
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'View',
                                    child: CoreElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LabelListScreen(
                                                    labelConditionModel: null,
                                                    redirectFrom: null,
                                                  )),
                                        );
                                      },
                                      coreButtonStyle:
                                          ThemeDataCenter.getViewButtonStyle(
                                              context),
                                      child: Text(CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'button.title.open')),
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
                              decoration: BoxDecoration(
                                color: ThemeDataCenter
                                    .getBottomBannerCardBackgroundColor(
                                        context),
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
                                      Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word: 'card.title.total'),
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(width: 5.0),
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
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(4.0, 2.0, 4.0, 2.0),
                  child: Card(
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:
                              ThemeDataCenter.getTemplateBorderCardColorStyle(
                                  context),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          // height: 150,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeDataCenter
                                  .getTopBannerCardBackgroundColor(context),
                              shape: BoxShape.rectangle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  const Icon(
                                    Icons.my_library_books_rounded,
                                    size: 26.0,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        125.0,
                                    child: Text(
                                      CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'screen.title.templates'),
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'View',
                                    child: CoreElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TemplateListScreen(
                                                    templateConditionModel:
                                                        null,
                                                    redirectFrom: null,
                                                  )),
                                        );
                                      },
                                      coreButtonStyle:
                                          ThemeDataCenter.getViewButtonStyle(
                                              context),
                                      child: Text(CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'button.title.open')),
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
                              decoration: BoxDecoration(
                                color: ThemeDataCenter
                                    .getBottomBannerCardBackgroundColor(
                                        context),
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
                                      Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word: 'card.title.total'),
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      const SizedBox(width: 5.0),
                                      Text(
                                        context
                                            .watch<TemplateNotifier>()
                                            .countAllTemplates
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
                ),

                _buildAdB(context, settingNotifier)
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initBannerAd();
  }

  onGetCountAll() async {
    countAllNotes = await NoteDatabaseManager.onCountAll();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar:
          settingNotifier.isSetBackgroundImage == true ? true : false,
      backgroundColor: settingNotifier.isSetBackgroundImage == true
          ? Colors.transparent
          : ThemeDataCenter.getBackgroundColor(context),
      appBar: _buildAppBar(context, settingNotifier),
      drawer: _buildDrawer(context),
      body: settingNotifier.isSetBackgroundImage == true
          ? DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        settingNotifier.backgroundImageSourceString ??
                            CommonStyles.backgroundImageSourceStringDefault()),
                    fit: BoxFit.cover),
              ),
              child: _buildStatisticHomeScreen(context, settingNotifier),
            )
          : _buildStatisticHomeScreen(context, settingNotifier),
      // bottomNavigationBar: settingNotifier.isSetBackgroundImage == true
      //     ? null
      //     : _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatingActionCreateButton(context),
    );
  }

  Widget _buildFloatingActionCreateButton(BuildContext context) {
    return AvatarGlow(
      glowRadiusFactor: 0.2,
      curve: Curves.linearToEaseOut,
      child: Tooltip(
        message: 'Create note',
        child: CoreElevatedButton.iconOnly(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NoteCreateScreen(
                        note: null,
                        copyNote: null,
                        subject: null,
                        actionMode: ActionModeEnum.create,
                        redirectFrom: RedirectFromEnum.home,
                      )),
            );
          },
          coreButtonStyle: ThemeDataCenter.getCoreScreenButtonStyle(
              context: context, customRadius: 40.0),
          icon: const SizedBox(
            width: 50.0,
            height: 50.0,
            child: Center(
              child: Icon(
                Icons.add_rounded,
                size: 35.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, SettingNotifier settingNotifier) {
    return AppBar(
      iconTheme: IconThemeData(
        color: ThemeDataCenter.getScreenTitleTextColor(context),
        size: 26,
      ),
      leading: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              style: CommonStyles.appbarLeadingBackButtonStyle(
                  whiteBlur:
                      settingNotifier.isSetBackgroundImage == true ? true : false),
              icon: const FaIcon(FontAwesomeIcons.barsStaggered),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          );
        }
      ),
      backgroundColor: settingNotifier.isSetBackgroundImage == true
          ? Colors.transparent
          : ThemeDataCenter.getBackgroundColor(context),
      elevation: 0,
      title: Row(
        children: [
          Text(widget.title,
              style: CommonStyles.screenTitleTextStyle(
                  fontSize: 30.0,
                  color: ThemeDataCenter.getScreenTitleTextColor(context))),
        ],
      ),
    );
  }

  CoreBottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return CoreBottomNavigationBar(
      // backgroundColor: ThemeDataCenter.getBackgroundColor(context),
      backgroundColor: Colors.transparent,
      child: _buildFloatingActionCreateButton(context),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CoreElevatedButton(
              coreButtonStyle:
                  ThemeDataCenter.getCoreScreenButtonStyle(context: context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Settings',
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CoreElevatedButton(
              coreButtonStyle:
                  ThemeDataCenter.getCoreScreenButtonStyle(context: context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('User manual',
                      style: GoogleFonts.montserrat(
                          fontStyle: FontStyle.italic,
                          fontSize: 18,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
