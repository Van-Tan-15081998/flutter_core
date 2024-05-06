import 'package:animate_do/animate_do.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_create_screen.dart';
import 'package:flutter_core_v3/app/screens/features/note/note_list_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../core/components/actions/common_buttons/CoreButtonStyle.dart';
import '../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../core/components/form/CoreTextFormField.dart';
import '../../../core/components/navigation/bottom_app_bar/CoreBottomNavigationBar.dart';
import '../../../core/components/notifications/CoreNotification.dart';
import '../../library/common/converters/CommonConverters.dart';
import '../../library/common/dimensions/CommonDimensions.dart';
import '../../library/common/languages/CommonLanguages.dart';
import '../../library/common/styles/CommonStyles.dart';
import '../../library/common/themes/ThemeDataCenter.dart';
import '../../library/common/utils/CommonAudioOnPressButton.dart';
import '../../library/enums/CommonEnums.dart';
import '../features/label/providers/label_notifier.dart';
import '../features/label/widgets/label_list_screen.dart';
import '../features/note/databases/note_db_manager.dart';
import '../features/note/providers/note_notifier.dart';
import '../features/subjects/databases/subject_db_manager.dart';
import '../features/subjects/models/subject_condition_model.dart';
import '../features/subjects/models/subject_model.dart';
import '../features/subjects/providers/subject_notifier.dart';
import '../features/subjects/widgets/functions/subject_shortcut_widget.dart';
import '../features/subjects/widgets/subject_list_folder_mode_screen.dart';
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
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
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
        }),
        request: const AdRequest());

    bannerAd.load();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myFocusNode = FocusNode();

  int countAllNotes = 0;
  int countAllLabels = 0;
  int countAllTasks = 0;
  bool isOpenShortcutList = false;
  List<SubjectModel> _subjectShortcutList = [];

  String avatarDescriptionString = '';
  String avatarDescriptionStringEdit = '';
  bool isOpenFormChangeAvatarDescription = false;

  Future<bool> _onUnShortcut(BuildContext context, SubjectModel subject) async {
    return await SubjectDatabaseManager.createShortcut(subject, null);
  }

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
                          Expanded(
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
                            message: '...',
                            child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ThemeDataCenter
                                        .getFilteringTextColorStyle(context),
                                    width: 1.0,
                                  ),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6.0)),
                                  image: DecorationImage(
                                      image: AssetImage(CommonStyles
                                              .adImageSourceStringList()[
                                          CommonConverters.getRandomNumber(
                                              maxNumber: CommonStyles
                                                      .adImageSourceStringList()
                                                  .length)]),
                                      fit: BoxFit.cover),
                                ),
                                child: const SizedBox(
                                  width: 70.0,
                                  height: 50.0,
                                )),
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
                                  Expanded(
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
                                      buttonAudio: commonAudioOnPressButton,
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
                                  Expanded(
                                    child: Text(
                                      CommonLanguages.convert(
                                          lang:
                                              settingNotifier.languageString ??
                                                  CommonLanguages
                                                      .languageStringDefault(),
                                          word: 'screen.title.subjects'),
                                      style: const TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Tooltip(
                                    message: 'View',
                                    child: CoreElevatedButton(
                                      buttonAudio: commonAudioOnPressButton,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const SubjectListFolderModeScreen(
                                              subjectConditionModel: null,
                                              redirectFrom: null,
                                              breadcrumb: null,
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
                                      _subjectShortcutList.isNotEmpty ? Expanded(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            highlightColor: Colors.black45,
                                            onTap: () {
                                              setState(() {
                                                isOpenShortcutList =
                                                    !isOpenShortcutList;
                                              });
                                            },
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.black45,
                                                    width: 1.0,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(
                                                              10.0)),
                                                  color: Colors.white
                                                      .withOpacity(0.65)),
                                              child: const Padding(
                                                padding: EdgeInsets.fromLTRB(
                                                    15.0, 6.0, 15.0, 6.0),
                                                child: Text('Shortcuts'),
                                              ),
                                            ),
                                          )
                                        ],
                                      )) : Container()
                                    ],
                                  ),
                                  isOpenShortcutList
                                      ? Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: List.generate(
                                                    _subjectShortcutList.length,
                                                    (index) => FadeIn(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      200),
                                                          animate: true,
                                                          child:
                                                              SubjectShortcutWidget(
                                                                  key: ValueKey<
                                                                      int>(_subjectShortcutList[
                                                                          index]
                                                                      .id!),
                                                                  index:
                                                                      index + 1,
                                                                  subject:
                                                                      _subjectShortcutList[
                                                                          index],
                                                                  onGoToDestination:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                SubjectListFolderModeScreen(
                                                                          subjectConditionModel:
                                                                              null,
                                                                          redirectFrom:
                                                                              null,
                                                                          breadcrumb: [
                                                                            _subjectShortcutList[index]
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  onDeleteShortcut:
                                                                      () async {
                                                                    _onUnShortcut(
                                                                            context,
                                                                            _subjectShortcutList[
                                                                                index])
                                                                        .then(
                                                                            (result) {
                                                                      if (result) {
                                                                        setState(
                                                                            () {
                                                                          _subjectShortcutList
                                                                              .removeAt(index);
                                                                        });
                                                                      } else {
                                                                        CoreNotification.show(
                                                                            context,
                                                                            CoreNotificationStatus.error,
                                                                            CoreNotificationAction.update,
                                                                            'Subject');
                                                                      }
                                                                    });
                                                                  }),
                                                        )),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container()
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
                                  Expanded(
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
                                      buttonAudio: commonAudioOnPressButton,
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
                                  Expanded(
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
                                      buttonAudio: commonAudioOnPressButton,
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

  Future<List<SubjectModel>?> _fetchSubjectShortcut() async {
    List<SubjectModel>? localLabelList =
        await SubjectDatabaseManager.shortcuts();

    return localLabelList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initBannerAd();

    _fetchSubjectShortcut().then((subjectsResult) {
      if (subjectsResult != null && subjectsResult.isNotEmpty) {
        setState(() {
          _subjectShortcutList = subjectsResult;
        });
      }
    });
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  onGetCountAll() async {
    countAllNotes = await NoteDatabaseManager.onCountAll();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);
    avatarDescriptionString = settingNotifier.avatarDescriptionString ?? '';
    avatarDescriptionStringEdit = avatarDescriptionString;

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar:
          settingNotifier.isSetBackgroundImage == true ? true : false,
      backgroundColor: settingNotifier.isSetBackgroundImage == true
          ? Colors.transparent
          : ThemeDataCenter.getBackgroundColor(context),
      appBar: _buildAppBar(context, settingNotifier),
      drawer: _buildDrawer(context, settingNotifier),
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
      floatingActionButton:
          _buildFloatingActionCreateButton(context, settingNotifier),
    );
  }

  Widget _buildFloatingActionCreateButton(
      BuildContext context, SettingNotifier settingNotifier) {
    return AvatarGlow(
      glowRadiusFactor: 0.2,
      curve: Curves.linearToEaseOut,
      child: Tooltip(
        message: CommonLanguages.convert(
            lang: settingNotifier.languageString ??
                CommonLanguages.languageStringDefault(),
            word: 'tooltip.button.createNote'),
        child: CoreElevatedButton.iconOnly(
          buttonAudio: commonAudioOnPressButton,
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
      leading: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            style: CommonStyles.appbarLeadingBackButtonStyle(
                whiteBlur: settingNotifier.isSetBackgroundImage == true
                    ? true
                    : false),
            icon: const FaIcon(FontAwesomeIcons.barsStaggered),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        );
      }),
      backgroundColor: settingNotifier.isSetBackgroundImage == true
          ? Colors.transparent
          : ThemeDataCenter.getBackgroundColor(context),
      elevation: 0,
      title: Row(
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              decoration: CommonStyles.titleScreenDecorationStyle(
                  settingNotifier.isSetBackgroundImage),
              child: Text(widget.title,
                  style: CommonStyles.screenTitleTextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      color: ThemeDataCenter.getScreenTitleTextColor(context))),
            ),
          ),
        ],
      ),
    );
  }

  CoreBottomNavigationBar _buildBottomNavigationBar(
      BuildContext context, SettingNotifier settingNotifier) {
    return CoreBottomNavigationBar(
      // backgroundColor: ThemeDataCenter.getBackgroundColor(context),
      backgroundColor: Colors.transparent,
      child: _buildFloatingActionCreateButton(context, settingNotifier),
    );
  }

  List<List<Color>> colorizeColors = [
    [Colors.white54, Colors.white, Colors.black12],
    [
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ],
    [
      Colors.amber,
      Colors.lightGreen,
    ],
    [Colors.tealAccent, Colors.blue, Colors.lightGreenAccent],
  ];

  Drawer _buildDrawer(BuildContext context, SettingNotifier settingNotifier) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF202124),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 30.0, 8.0, 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60.0,
                      width: double.infinity,
                      child: DefaultTextStyle(
                        style: GoogleFonts.montserrat(
                            fontStyle: FontStyle.italic,
                            fontSize: 35.0,
                            fontWeight: FontWeight.bold),
                        child: AnimatedTextKit(
                          totalRepeatCount: 30,
                          animatedTexts: [
                            TypewriterAnimatedText('Hi Notes',
                                speed: const Duration(milliseconds: 300)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white54,
                                width: 1.0,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50.0)),
                              image: DecorationImage(
                                  image: AssetImage(CommonStyles
                                      .avatarImageSourceStringList()),
                                  fit: BoxFit.cover),
                            ),
                            child: const SizedBox(
                              width: 100.0,
                              height: 100.0,
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 2.0, 10.0, 2.0),
                            child: Center(
                              child: InkWell(
                                onLongPress: () {
                                  setState(() {
                                    myController.text =
                                        avatarDescriptionStringEdit;
                                    isOpenFormChangeAvatarDescription =
                                        !isOpenFormChangeAvatarDescription;

                                    myFocusNode.requestFocus();
                                  });
                                },
                                child: AnimatedTextKit(
                                  animatedTexts: [
                                    ColorizeAnimatedText(
                                      '"$avatarDescriptionString"',
                                      textStyle: GoogleFonts.montserrat(
                                        fontStyle: FontStyle.italic,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      colors: colorizeColors[
                                          CommonConverters.getRandomNumber(
                                              maxNumber:
                                                  colorizeColors.length)],
                                    ),
                                  ],
                                  totalRepeatCount: 30,
                                  isRepeatingAnimation: true,
                                  onTap: () {},
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    isOpenFormChangeAvatarDescription
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Form(
                                  key: _formKey,
                                  child: CoreTextFormField(
                                    style:
                                        const TextStyle(color: Colors.white54),
                                    onChanged: (value) {
                                        avatarDescriptionStringEdit = value;
                                    },
                                    controller: myController,
                                    focusNode: myFocusNode,
                                    validateString:
                                        'Please enter your description',
                                    maxLength: 200,
                                    icon: const Icon(Icons.edit,
                                        color: Colors.white54),
                                    label: 'Description',
                                    labelColor: Colors.white54,
                                    placeholder: 'Enter you description',
                                    helper: '',
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    isOpenFormChangeAvatarDescription
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CoreElevatedButton.iconOnly(
                                buttonAudio: commonAudioOnPressButton,
                                icon:
                                    const Icon(Icons.close_rounded, size: 25.0),
                                onPressed: () {
                                  setState(() {
                                    isOpenFormChangeAvatarDescription = false;
                                  });
                                },
                                coreButtonStyle:
                                    ThemeDataCenter.getCoreScreenButtonStyle(
                                        context: context),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              CoreElevatedButton.iconOnly(
                                buttonAudio: commonAudioOnPressButton,
                                icon: const Icon(Icons.check, size: 25.0),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    settingNotifier
                                        .setAvatarDescription(myController.text)
                                        .then((result) {
                                      if (result) {
                                        setState(() {
                                          isOpenFormChangeAvatarDescription =
                                              false;
                                          avatarDescriptionStringEdit =
                                              avatarDescriptionString;
                                        });
                                        if (myFocusNode.hasFocus) {
                                          myFocusNode.unfocus();
                                        }
                                        CoreNotification.show(
                                            context,
                                            CoreNotificationStatus.success,
                                            CoreNotificationAction.update,
                                            'Theme');
                                      }
                                    });
                                  }
                                },
                                coreButtonStyle:
                                    ThemeDataCenter.getCoreScreenButtonStyle(
                                        context: context),
                              ),
                            ],
                          )
                        : Container()
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CoreElevatedButton(
              buttonAudio: commonAudioOnPressButton,
              coreButtonStyle:
                  ThemeDataCenter.getCoreScreenButtonStyle(context: context),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      CommonLanguages.convert(
                          lang: settingNotifier.languageString ??
                              CommonLanguages.languageStringDefault(),
                          word: 'button.title.setting'),
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
              buttonAudio: commonAudioOnPressButton,
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
