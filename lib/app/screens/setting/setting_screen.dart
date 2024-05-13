import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/library/common/languages/CommonLanguages.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../core/components/actions/common_buttons/CoreElevatedButton.dart';
import '../../../core/components/notifications/CoreNotification.dart';
import '../../library/common/dimensions/CommonDimensions.dart';
import '../../library/common/styles/CommonStyles.dart';
import '../../library/common/themes/ThemeDataCenter.dart';
import '../../library/common/utils/CommonAudioBackground.dart';
import '../../library/common/utils/CommonAudioOnPressButton.dart';
import '../home/home_screen.dart';
import 'providers/setting_notifier.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  CommonAudioOnPressButton commonAudioOnPressButton =
      CommonAudioOnPressButton();
  TextStyle itemLabelTextStyle(BuildContext context) {
    return const TextStyle(
        color: Color(0xFF1f1f1f), fontSize: 18.0, fontWeight: FontWeight.w400);
  }

  bool isSetColorAccordingSubjectColor = false;
  bool isStickTitleOfNote = false;
  bool isExpandedNoteContent = false;
  bool isExpandedSubjectActions = false;
  bool isExpandedTemplateContent = false;
  bool isSetBackgroundImage = false;
  String? backgroundImageSourceString;

  String? languageString;

  String? themeString;
  bool isSetThemeDefault = false;
  bool isSetThemeBlackAndWhite = false;
  bool isSetThemeBeachTowels = false;
  bool isSetThemeBeautifulBlues = false;
  bool isSetThemeMoonlightBytes = false;
  bool isSetThemeNumber3 = false;
  bool isSetThemeAndroidLollipop = false;
  bool isSetThemeRainbowDash = false;
  bool isSetThemeShadesOfWhite = false;
  bool isSetThemeBlueberryBasket = false;
  bool isSetThemeBeach = false;
  bool isSetThemeCappuccino = false;
  bool isSetThemeGreyLavenderColors = false;
  bool isSetThemeMetroUIColors = false;
  bool isSetThemePinks = false;
  bool isSetThemeNeverDoubt = false;
  bool isSetThemeProgramCatalog = false;

  bool isSettingOpacity = false;
  double opacityNumber = 1;

  Widget setThemeDefault(SettingNotifier settingNotifier) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SwitchListTile(
                contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text('Default',
                              style: itemLabelTextStyle(context)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    Row(
                      children: [
                        Container(
                            width: 20.0,
                            height: 8.0,
                            color: const Color(0xff1f1f1f)),
                        Container(
                            width: 20.0,
                            height: 8.0,
                            color: const Color(0xff1f1f1f)),
                        Container(
                            width: 20.0,
                            height: 8.0,
                            color: const Color(0xff1f1f1f)),
                        Container(
                            width: 20.0,
                            height: 8.0,
                            color: const Color(0xff1f1f1f)),
                        Container(
                            width: 20.0,
                            height: 8.0,
                            color: const Color(0xff1f1f1f)),
                      ],
                    )
                  ],
                ),
                value: isSetThemeDefault,
                onChanged: (bool value) {
                  setState(() {
                    isSetThemeDefault = value;

                    if (isSetThemeDefault) {
                      settingNotifier
                          .setThemeString('isSetThemeDefault')
                          .then((result) {
                        if (result) {
                          isSetThemeBlackAndWhite = false;
                          isSetThemeBeachTowels = false;
                          isSetThemeBeautifulBlues = false;
                          isSetThemeMoonlightBytes = false;
                          isSetThemeNumber3 = false;
                          isSetThemeAndroidLollipop = false;
                          isSetThemeRainbowDash = false;
                          isSetThemeShadesOfWhite = false;
                          isSetThemeBlueberryBasket = false;
                          isSetThemeBeach = false;
                          isSetThemeCappuccino = false;
                          isSetThemeGreyLavenderColors = false;
                          isSetThemeMetroUIColors = false;
                          isSetThemePinks = false;
                          isSetThemeNeverDoubt = false;
                          isSetThemeProgramCatalog = false;

                          CoreNotification.showMessage(
                              context,
                              settingNotifier,
                              CoreNotificationStatus.success,
                              CommonLanguages.convert(
                                  lang: settingNotifier.languageString ??
                                      CommonLanguages.languageStringDefault(),
                                  word: 'notification.action.updatedSetting'));
                        }
                      });
                    } else {}
                  });
                });
          },
        ));
  }

  Widget setThemeBlackAndWhite(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Black and White',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xff1f1f1f)),
                    Container(width: 20.0, height: 8.0, color: Colors.white),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xff1f1f1f)),
                    Container(width: 20.0, height: 8.0, color: Colors.white),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xff1f1f1f)),
                  ],
                )
              ],
            ),
            value: isSetThemeBlackAndWhite,
            onChanged: (bool value) {
              setState(() {
                isSetThemeBlackAndWhite = value;

                if (isSetThemeBlackAndWhite) {
                  settingNotifier
                      .setThemeString('isSetThemeBlackAndWhite')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeBeachTowels(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Beach Towels',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfe4a49)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF2ab7ca)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfed766)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFe6e6ea)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFf4f4f8)),
                  ],
                )
              ],
            ),
            value: isSetThemeBeachTowels,
            onChanged: (bool value) {
              setState(() {
                isSetThemeBeachTowels = value;

                if (isSetThemeBeachTowels) {
                  settingNotifier
                      .setThemeString('isSetThemeBeachTowels')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeBeautifulBlues(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Beautiful Blues',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF011f4b)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF03396c)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF005b96)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF6497b1)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFb3cde0)),
                  ],
                )
              ],
            ),
            value: isSetThemeBeautifulBlues,
            onChanged: (bool value) {
              setState(() {
                isSetThemeBeautifulBlues = value;

                if (isSetThemeBeautifulBlues) {
                  settingNotifier
                      .setThemeString('isSetThemeBeautifulBlues')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeMoonlightBytes(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child:
                          Text('Moonlight', style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF4a4e4d)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF0e9aa7)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF3da4ab)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFf6cd61)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfe8a71)),
                  ],
                )
              ],
            ),
            value: isSetThemeMoonlightBytes,
            onChanged: (bool value) {
              setState(() {
                isSetThemeMoonlightBytes = value;

                if (isSetThemeMoonlightBytes) {
                  settingNotifier
                      .setThemeString('isSetThemeMoonlightBytes')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeNumber3(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child:
                          Text('Number 3', style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF2a4d69)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF4b86b4)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFadcbe3)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFe7eff6)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF63ace5)),
                  ],
                )
              ],
            ),
            value: isSetThemeNumber3,
            onChanged: (bool value) {
              setState(() {
                isSetThemeNumber3 = value;

                if (isSetThemeNumber3) {
                  settingNotifier
                      .setThemeString('isSetThemeNumber3')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeAndroidLollipop(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child:
                          Text('Lollipop', style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF009688)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF35a79c)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF54b2a9)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF65c3ba)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF83d0c9)),
                  ],
                )
              ],
            ),
            value: isSetThemeAndroidLollipop,
            onChanged: (bool value) {
              setState(() {
                isSetThemeAndroidLollipop = value;

                if (isSetThemeAndroidLollipop) {
                  settingNotifier
                      .setThemeString('isSetThemeAndroidLollipop')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeRainbowDash(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child:
                          Text('Rainbow', style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFee4035)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFf37736)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfdf498)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF7bc043)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF0392cf)),
                  ],
                )
              ],
            ),
            value: isSetThemeRainbowDash,
            onChanged: (bool value) {
              setState(() {
                isSetThemeRainbowDash = value;

                if (isSetThemeRainbowDash) {
                  settingNotifier
                      .setThemeString('isSetThemeRainbowDash')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeShadesOfWhite(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Shades of White',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfaf0e6)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfff5ee)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfdf5e6)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfaf0e6)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfaebd7)),
                  ],
                )
              ],
            ),
            value: isSetThemeShadesOfWhite,
            onChanged: (bool value) {
              setState(() {
                isSetThemeShadesOfWhite = value;

                if (isSetThemeShadesOfWhite) {
                  settingNotifier
                      .setThemeString('isSetThemeShadesOfWhite')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeBlueberryBasket(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Blueberry Basket',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFffffff)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFd0e1f9)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF4d648d)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF283655)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF1e1f26)),
                  ],
                )
              ],
            ),
            value: isSetThemeBlueberryBasket,
            onChanged: (bool value) {
              setState(() {
                isSetThemeBlueberryBasket = value;

                if (isSetThemeBlueberryBasket) {
                  settingNotifier
                      .setThemeString('isSetThemeBlueberryBasket')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeBeach(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Beach', style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF96ceb4)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFffeead)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFff6f69)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFffcc5c)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF88d8b0)),
                  ],
                )
              ],
            ),
            value: isSetThemeBeach,
            onChanged: (bool value) {
              setState(() {
                isSetThemeBeach = value;

                if (isSetThemeBeach) {
                  settingNotifier
                      .setThemeString('isSetThemeBeach')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeCappuccino(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Cappuccino',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF4b3832)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF854442)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFfff4e6)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF3c2f2f)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFbe9b7b)),
                  ],
                )
              ],
            ),
            value: isSetThemeCappuccino,
            onChanged: (bool value) {
              setState(() {
                isSetThemeCappuccino = value;

                if (isSetThemeCappuccino) {
                  settingNotifier
                      .setThemeString('isSetThemeCappuccino')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeGreyLavenderColors(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Grey Lavender',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFd2d4dc)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFafafaf)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFf8f8fa)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFe5e6eb)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFc0c2ce)),
                  ],
                )
              ],
            ),
            value: isSetThemeGreyLavenderColors,
            onChanged: (bool value) {
              setState(() {
                isSetThemeGreyLavenderColors = value;

                if (isSetThemeGreyLavenderColors) {
                  settingNotifier
                      .setThemeString('isSetThemeGreyLavenderColors')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeMetroUIColors(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Metro Colors',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFd11141)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF00b159)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF00aedb)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFf37735)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFffc425)),
                  ],
                )
              ],
            ),
            value: isSetThemeMetroUIColors,
            onChanged: (bool value) {
              setState(() {
                isSetThemeMetroUIColors = value;

                if (isSetThemeMetroUIColors) {
                  settingNotifier
                      .setThemeString('isSetThemeMetroUIColors')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemePinks(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Pinks', style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFff77aa)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFff99cc)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFffbbee)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFff5588)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFff3377)),
                  ],
                )
              ],
            ),
            value: isSetThemePinks,
            onChanged: (bool value) {
              setState(() {
                isSetThemePinks = value;

                if (isSetThemePinks) {
                  settingNotifier
                      .setThemeString('isSetThemePinks')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemeNeverDoubt = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeNeverDoubt(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Never Doubt',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFeeeeee)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFdddddd)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFcccccc)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFbbbbbb)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF29a8ab)),
                  ],
                )
              ],
            ),
            value: isSetThemeNeverDoubt,
            onChanged: (bool value) {
              setState(() {
                isSetThemeNeverDoubt = value;

                if (isSetThemeNeverDoubt) {
                  settingNotifier
                      .setThemeString('isSetThemeNeverDoubt')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeProgramCatalog = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  Widget setThemeProgramCatalog(SettingNotifier settingNotifier) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 5, 0, 5),
      child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return SwitchListTile(
            contentPadding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('Program Catalog',
                          style: itemLabelTextStyle(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
                Row(
                  children: [
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFedc951)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFeb6841)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFFcc2a36)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF4f372d)),
                    Container(
                        width: 20.0,
                        height: 8.0,
                        color: const Color(0xFF00a0b0)),
                  ],
                )
              ],
            ),
            value: isSetThemeProgramCatalog,
            onChanged: (bool value) {
              setState(() {
                isSetThemeProgramCatalog = value;

                if (isSetThemeProgramCatalog) {
                  settingNotifier
                      .setThemeString('isSetThemeProgramCatalog')
                      .then((result) {
                    if (result) {
                      isSetThemeDefault = false;
                      isSetThemeBlackAndWhite = false;
                      isSetThemeBeachTowels = false;
                      isSetThemeBeautifulBlues = false;
                      isSetThemeMoonlightBytes = false;
                      isSetThemeNumber3 = false;
                      isSetThemeAndroidLollipop = false;
                      isSetThemeRainbowDash = false;
                      isSetThemeShadesOfWhite = false;
                      isSetThemeBlueberryBasket = false;
                      isSetThemeBeach = false;
                      isSetThemeCappuccino = false;
                      isSetThemeGreyLavenderColors = false;
                      isSetThemeMetroUIColors = false;
                      isSetThemePinks = false;
                      isSetThemeNeverDoubt = false;

                      CoreNotification.showMessage(
                          context,
                          settingNotifier,
                          CoreNotificationStatus.success,
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'notification.action.updatedSetting'));
                    }
                  });
                } else {
                  isSetThemeDefault = true;
                  settingNotifier.setThemeString('isSetThemeDefault');
                }
              });
            });
      }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    commonAudioOnPressButton.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingNotifier = Provider.of<SettingNotifier>(context);
    isSetColorAccordingSubjectColor =
        settingNotifier.isSetColorAccordingSubjectColor ?? false;
    isStickTitleOfNote = settingNotifier.isStickTitleOfNote ?? false;
    isExpandedNoteContent = settingNotifier.isExpandedNoteContent ?? false;
    isExpandedSubjectActions =
        settingNotifier.isExpandedSubjectActions ?? false;
    isExpandedTemplateContent =
        settingNotifier.isExpandedTemplateContent ?? false;
    isSetBackgroundImage = settingNotifier.isSetBackgroundImage ?? false;

    themeString = settingNotifier.themeString;
    backgroundImageSourceString = settingNotifier.backgroundImageSourceString;
    languageString = settingNotifier.languageString;

    opacityNumber = settingNotifier.opacityNumber ?? 1;

    switch (themeString) {
      case 'isSetThemeDefault':
        {
          isSetThemeDefault = true;
          break;
        }
      case 'isSetThemeBlackAndWhite':
        {
          isSetThemeBlackAndWhite = true;
          break;
        }
      case 'isSetThemeBeachTowels':
        {
          isSetThemeBeachTowels = true;
          break;
        }
      case 'isSetThemeBeautifulBlues':
        {
          isSetThemeBeautifulBlues = true;
          break;
        }
      case 'isSetThemeMoonlightBytes':
        {
          isSetThemeMoonlightBytes = true;
          break;
        }
      case 'isSetThemeNumber3':
        {
          isSetThemeNumber3 = true;
          break;
        }
      case 'isSetThemeAndroidLollipop':
        {
          isSetThemeAndroidLollipop = true;
          break;
        }
      case 'isSetThemeRainbowDash':
        {
          isSetThemeRainbowDash = true;
          break;
        }
      case 'isSetThemeShadesOfWhite':
        {
          isSetThemeShadesOfWhite = true;
          break;
        }
      case 'isSetThemeBlueberryBasket':
        {
          isSetThemeBlueberryBasket = true;
          break;
        }
      case 'isSetThemeBeach':
        {
          isSetThemeBeach = true;
          break;
        }
      case 'isSetThemeCappuccino':
        {
          isSetThemeCappuccino = true;
          break;
        }
      case 'isSetThemeGreyLavenderColors':
        {
          isSetThemeGreyLavenderColors = true;
          break;
        }
      case 'isSetThemeMetroUIColors':
        {
          isSetThemeMetroUIColors = true;
          break;
        }
      case 'isSetThemePinks':
        {
          isSetThemePinks = true;
          break;
        }
      case 'isSetThemeNeverDoubt':
        {
          isSetThemeNeverDoubt = true;
          break;
        }
      case 'isSetThemeProgramCatalog':
        {
          isSetThemeProgramCatalog = true;
          break;
        }
    }

    return Scaffold(
      extendBodyBehindAppBar:
          settingNotifier.isSetBackgroundImage == true ? true : false,
      backgroundColor: settingNotifier.isSetBackgroundImage == true
          ? Colors.transparent
          : ThemeDataCenter.getBackgroundColor(context),
      appBar: _buildAppBar(context, settingNotifier),
      body: settingNotifier.isSetBackgroundImage == true
          ? DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        settingNotifier.backgroundImageSourceString ??
                            CommonStyles.backgroundImageSourceStringDefault()),
                    fit: BoxFit.cover),
              ),
              child: _buildBody(context, settingNotifier),
            )
          : _buildBody(context, settingNotifier),
    );
  }

  Widget _buildBody(BuildContext context, SettingNotifier settingNotifier) {
    return Column(
      children: [
        settingNotifier.isSetBackgroundImage == true
            ? SizedBox(height: CommonDimensions.scaffoldAppBarHeight(context))
            : Container(),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  Card(
                    color: Colors.transparent,
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:
                              ThemeDataCenter.getBorderCardColorStyle(context),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        StickyHeader(
                          header: SizedBox(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xFF202124),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word:
                                                'screen.title.settings.display'),
                                        style: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 20,
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          content: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                  settingNotifier.opacityNumber ?? 0.85),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SwitchListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                2, 2, 2, 2),
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'screen.title.settings.setBackgroundColorIsSubjectColor'),
                                                  style: itemLabelTextStyle(
                                                      context)),
                                            ),
                                          ],
                                        ),
                                        value: isSetColorAccordingSubjectColor,
                                        onChanged: (bool value) {
                                          setState(
                                            () {
                                              settingNotifier
                                                  .setIsSetColorAccordingSubjectColor(
                                                      value)
                                                  .then(
                                                (success) {
                                                  if (success) {
                                                    setState(() {
                                                      isSetColorAccordingSubjectColor =
                                                          value;
                                                    });

                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.updatedSetting'));
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SwitchListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                2, 2, 2, 2),
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'screen.title.settings.setNoteContentExpanded'),
                                                  style: itemLabelTextStyle(
                                                      context)),
                                            ),
                                          ],
                                        ),
                                        value: isExpandedNoteContent,
                                        onChanged: (bool value) {
                                          setState(
                                            () {
                                              settingNotifier
                                                  .setIsExpandedNoteContent(
                                                      value)
                                                  .then(
                                                (success) {
                                                  if (success) {
                                                    setState(() {
                                                      isExpandedNoteContent =
                                                          value;
                                                    });

                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.updatedSetting'));
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SwitchListTile(
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                2, 2, 2, 2),
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'screen.title.settings.setTemplateContentExpanded'),
                                                  style: itemLabelTextStyle(
                                                      context)),
                                            ),
                                          ],
                                        ),
                                        value: isExpandedTemplateContent,
                                        onChanged: (bool value) {
                                          setState(
                                            () {
                                              settingNotifier
                                                  .setIsExpandedTemplateContent(
                                                      value)
                                                  .then(
                                                (success) {
                                                  if (success) {
                                                    setState(() {
                                                      isExpandedTemplateContent =
                                                          value;
                                                    });

                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.updatedSetting'));
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SwitchListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                2, 2, 2, 2),
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'screen.title.settings.setSubjectActionsExpanded'),
                                                  style: itemLabelTextStyle(
                                                      context)),
                                            ),
                                          ],
                                        ),
                                        value: isExpandedSubjectActions,
                                        onChanged: (bool value) {
                                          setState(
                                            () {
                                              settingNotifier
                                                  .setIsExpandedSubjectActions(
                                                      value)
                                                  .then(
                                                (success) {
                                                  if (success) {
                                                    setState(() {
                                                      isExpandedSubjectActions =
                                                          value;
                                                    });

                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.updatedSetting'));
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SwitchListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                2, 2, 2, 2),
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'screen.title.settings.setStickTitleOfNoteWhenScroll'),
                                                  style: itemLabelTextStyle(
                                                      context)),
                                            ),
                                          ],
                                        ),
                                        value: isStickTitleOfNote,
                                        onChanged: (bool value) {
                                          setState(
                                            () {
                                              settingNotifier
                                                  .setIsStickTitleOfNote(value)
                                                  .then(
                                                (success) {
                                                  if (success) {
                                                    setState(() {
                                                      isStickTitleOfNote =
                                                          value;
                                                    });

                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.updatedSetting'));
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SizedBox(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                            CommonLanguages.convert(
                                                                lang: settingNotifier
                                                                        .languageString ??
                                                                    CommonLanguages
                                                                        .languageStringDefault(),
                                                                word:
                                                                    'screen.title.settings.opacityNumber'),
                                                            style:
                                                                itemLabelTextStyle(
                                                                    context)),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Slider(
                                                          value: opacityNumber,
                                                          max: 1,
                                                          divisions: 20,
                                                          label: opacityNumber
                                                              .toString(),
                                                          onChanged:
                                                              (double value) {
                                                            if (!isSettingOpacity) {
                                                              isSettingOpacity =
                                                                  true;
                                                              settingNotifier
                                                                  .setOpacityNumber(
                                                                      value)
                                                                  .then(
                                                                      (result) {
                                                                if (result) {
                                                                  isSettingOpacity =
                                                                      false;
                                                                }
                                                              });
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 5, 0, 5),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SwitchListTile(
                                        dense: true,
                                        contentPadding:
                                            const EdgeInsets.fromLTRB(
                                                2, 2, 2, 2),
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                  CommonLanguages.convert(
                                                      lang: settingNotifier
                                                              .languageString ??
                                                          CommonLanguages
                                                              .languageStringDefault(),
                                                      word:
                                                          'screen.title.settings.setBackgroundImage'),
                                                  style: itemLabelTextStyle(
                                                      context)),
                                            ),
                                          ],
                                        ),
                                        value: isSetBackgroundImage,
                                        onChanged: (bool value) {
                                          setState(
                                            () {
                                              settingNotifier
                                                  .setIsSetBackgroundImage(
                                                      value)
                                                  .then(
                                                (success) async {
                                                  if (success) {
                                                    setState(() {
                                                      isSetBackgroundImage =
                                                          value;
                                                    });

                                                    CoreNotification.showMessage(
                                                        context,
                                                        settingNotifier,
                                                        CoreNotificationStatus
                                                            .success,
                                                        CommonLanguages.convert(
                                                            lang: settingNotifier
                                                                    .languageString ??
                                                                CommonLanguages
                                                                    .languageStringDefault(),
                                                            word:
                                                                'notification.action.updatedSetting'));
                                                  }
                                                },
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                isSetBackgroundImage
                                    ? SizedBox(
                                        height: 230.0,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: CommonStyles
                                                  .backgroundImageSourceStringList()
                                              .length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(
                                                        () {
                                                          settingNotifier
                                                              .setBackgroundImageSourceString(
                                                                  CommonStyles
                                                                          .backgroundImageSourceStringList()[
                                                                      index])
                                                              .then(
                                                            (success) async {
                                                              if (success) {
                                                                setState(() {
                                                                  backgroundImageSourceString =
                                                                      CommonStyles
                                                                              .backgroundImageSourceStringList()[
                                                                          index];
                                                                });

                                                                CoreNotification.showMessage(
                                                                    context,
                                                                    settingNotifier,
                                                                    CoreNotificationStatus
                                                                        .success,
                                                                    CommonLanguages.convert(
                                                                        lang: settingNotifier.languageString ??
                                                                            CommonLanguages
                                                                                .languageStringDefault(),
                                                                        word:
                                                                            'notification.action.updatedSetting'));
                                                              }
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Card(
                                                      elevation:
                                                          4, // Độ nổi của thẻ
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10), // Bo tròn góc của thẻ
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Container(
                                                            height: 180.0,
                                                            width: 100.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      CommonStyles
                                                                              .backgroundImageSourceStringList()[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  backgroundImageSourceString !=
                                                              null &&
                                                          backgroundImageSourceString ==
                                                              CommonStyles
                                                                      .backgroundImageSourceStringList()[
                                                                  index]
                                                      ? const Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .circleCheck,
                                                                  color: Colors
                                                                      .lightGreenAccent,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Card(
                    color: Colors.transparent,
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:
                              ThemeDataCenter.getBorderCardColorStyle(context),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        StickyHeader(
                          header: SizedBox(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xFF202124),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word:
                                                'screen.title.settings.languages'),
                                        style: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 20,
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          content: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    settingNotifier.opacityNumber ?? 0.85),
                              ),
                              child: SizedBox(
                                height: 450,
                                child: GridView.count(
                                    primary: false,
                                    padding: const EdgeInsets.all(20),
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 3,
                                    children: List.generate(
                                        CommonLanguages.languageStringList()
                                            .length,
                                        (index) => Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(
                                                        () {
                                                          settingNotifier
                                                              .setLanguageString(
                                                                  CommonLanguages
                                                                          .languageStringList()[
                                                                      index])
                                                              .then(
                                                            (success) async {
                                                              if (success) {
                                                                setState(() {
                                                                  languageString =
                                                                      CommonLanguages
                                                                              .languageStringList()[
                                                                          index];
                                                                });

                                                                CoreNotification.showMessage(
                                                                    context,
                                                                    settingNotifier,
                                                                    CoreNotificationStatus
                                                                        .success,
                                                                    CommonLanguages.convert(
                                                                        lang: settingNotifier.languageString ??
                                                                            CommonLanguages
                                                                                .languageStringDefault(),
                                                                        word:
                                                                            'notification.action.updatedSetting'));
                                                              }
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    child: Card(
                                                      elevation:
                                                          4, // Độ nổi của thẻ
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                10), // Bo tròn góc của thẻ
                                                      ),
                                                      child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Container(
                                                            height: 60.0,
                                                            width: 100.0,
                                                            decoration:
                                                                BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: AssetImage(
                                                                      CommonLanguages.flagLanguageSourceString(
                                                                          CommonLanguages.languageStringList()[
                                                                              index])),
                                                                  fit: BoxFit
                                                                      .cover),
                                                            ),
                                                          )),
                                                    ),
                                                  ),
                                                  languageString != null &&
                                                          languageString ==
                                                              CommonLanguages
                                                                      .languageStringList()[
                                                                  index]
                                                      ? const Positioned(
                                                          top: 0,
                                                          right: 0,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: FaIcon(
                                                                  FontAwesomeIcons
                                                                      .circleCheck,
                                                                  color: Colors
                                                                      .lightGreenAccent,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : Container()
                                                ],
                                              ),
                                            ))),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Card(
                    color: Colors.transparent,
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:
                              ThemeDataCenter.getBorderCardColorStyle(context),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        StickyHeader(
                          header: SizedBox(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xFF202124),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word:
                                                'screen.title.settings.backgroundMusic'),
                                        style: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 20,
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          content: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    settingNotifier.opacityNumber ?? 0.85),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Column(
                                        children: [
                                          CoreElevatedButton.iconOnly(
                                            buttonAudio:
                                                commonAudioOnPressButton,
                                            icon: const Icon(
                                                Icons.playlist_play_rounded,
                                                size: 25.0),
                                            onPressed: () {
                                              settingNotifier
                                                  .setPlayingBackgroundMusicSourceString(
                                                      "ALL");
                                            },
                                            coreButtonStyle: ThemeDataCenter
                                                .getCoreScreenButtonStyle(
                                                    context: context),
                                          ),
                                          CoreElevatedButton.iconOnly(
                                            buttonAudio:
                                                commonAudioOnPressButton,
                                            icon: settingNotifier
                                                        .playingBackgroundMusicSourceString ==
                                                    'TURNOFF'
                                                ? const Icon(
                                                    Icons.music_off_rounded,
                                                    size: 25.0)
                                                : const Icon(
                                                    Icons.music_note_rounded,
                                                    size: 25.0),
                                            onPressed: () {
                                              if (settingNotifier
                                                      .playingBackgroundMusicSourceString !=
                                                  'TURNOFF') {
                                                settingNotifier
                                                    .setPlayingBackgroundMusicSourceString(
                                                        'TURNOFF');
                                              } else {
                                                settingNotifier
                                                    .setPlayingBackgroundMusicSourceString(
                                                        "ALL");
                                              }
                                            },
                                            coreButtonStyle: ThemeDataCenter
                                                .getCoreScreenButtonStyle(
                                                    context: context),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        settingNotifier
                                                    .playingBackgroundMusicSourceString ==
                                                'ALL'
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: InkWell(
                                                  highlightColor:
                                                      Colors.black45,
                                                  onTap: () {},
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color:
                                                              Colors.blueAccent,
                                                          width: 2.0,
                                                        ),
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    10.0)),
                                                        color: Colors.white
                                                            .withOpacity(0.65)),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              15.0,
                                                              6.0,
                                                              15.0,
                                                              6.0),
                                                      child: Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .playlist_play_rounded,
                                                              size: 25.0),
                                                          Text(
                                                              'Playing all now'),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            : Container(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: List.generate(
                                                      CommonAudioBackground
                                                              .backgroundMusicList()
                                                          .length,
                                                      (index) => Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: InkWell(
                                                            highlightColor:
                                                                Colors.black45,
                                                            onTap: () {
                                                              setState(() {
                                                                settingNotifier.setPlayingBackgroundMusicSourceString(
                                                                    CommonAudioBackground
                                                                            .backgroundMusicList()[
                                                                        index]);
                                                              });
                                                            },
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: settingNotifier.playingBackgroundMusicSourceString ==
                                                                                CommonAudioBackground.backgroundMusicList()[index]
                                                                            ? Colors.blueAccent
                                                                            : Colors.black45,
                                                                        width: settingNotifier.playingBackgroundMusicSourceString ==
                                                                                CommonAudioBackground.backgroundMusicList()[index]
                                                                            ? 2.0
                                                                            : 1.0,
                                                                      ),
                                                                      borderRadius: const BorderRadius
                                                                              .all(
                                                                          Radius.circular(
                                                                              10.0)),
                                                                      color: Colors
                                                                          .white
                                                                          .withOpacity(
                                                                              0.65)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        15.0,
                                                                        6.0,
                                                                        15.0,
                                                                        6.0),
                                                                child: Row(
                                                                  children: [
                                                                    const Icon(
                                                                        Icons
                                                                            .music_note_rounded,
                                                                        size:
                                                                            25.0),
                                                                    Text(
                                                                        'Sound 0${index + 1}'),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ))),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ))
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Card(
                    color: Colors.transparent,
                    shadowColor: const Color(0xff1f1f1f),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color:
                              ThemeDataCenter.getBorderCardColorStyle(context),
                          width: 1.0),
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        StickyHeader(
                          header: SizedBox(
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Color(0xFF202124),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(4, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        CommonLanguages.convert(
                                            lang: settingNotifier
                                                    .languageString ??
                                                CommonLanguages
                                                    .languageStringDefault(),
                                            word:
                                                'screen.title.settings.colorThemes'),
                                        style: GoogleFonts.montserrat(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 20,
                                            color: Colors.white54,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          content: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(
                                  settingNotifier.opacityNumber ?? 0.85),
                            ),
                            child: Column(
                              children: [
                                setThemeDefault(settingNotifier),
                                setThemeBlackAndWhite(settingNotifier),
                                setThemeBeachTowels(settingNotifier),
                                setThemeBeautifulBlues(settingNotifier),
                                setThemeMoonlightBytes(settingNotifier),
                                setThemeNumber3(settingNotifier),
                                setThemeAndroidLollipop(settingNotifier),
                                setThemeRainbowDash(settingNotifier),
                                setThemeShadesOfWhite(settingNotifier),
                                setThemeBlueberryBasket(settingNotifier),
                                setThemeBeach(settingNotifier),
                                setThemeCappuccino(settingNotifier),
                                setThemeGreyLavenderColors(settingNotifier),
                                setThemeMetroUIColors(settingNotifier),
                                setThemePinks(settingNotifier),
                                setThemeNeverDoubt(settingNotifier),
                                setThemeProgramCatalog(settingNotifier),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25.0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onPopAction(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen(
                  title: 'Hi Notes',
                )),
        (route) => false,
      );
    }
  }

  Widget? _buildAppbarLeading(
      BuildContext context, SettingNotifier settingNotifier) {
    return IconButton(
      style: CommonStyles.appbarLeadingBackButtonStyle(
          whiteBlur:
              settingNotifier.isSetBackgroundImage == true ? true : false),
      icon: const FaIcon(FontAwesomeIcons.chevronLeft),
      onPressed: () {
        _onPopAction(context);
      },
    );
  }

  AppBar _buildAppBar(BuildContext context, SettingNotifier settingNotifier) {
    return AppBar(
      iconTheme: IconThemeData(
        color: ThemeDataCenter.getScreenTitleTextColor(context),
        size: 26,
      ),
      leading: _buildAppbarLeading(context, settingNotifier),
      actions: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          child: CoreElevatedButton.iconOnly(
            buttonAudio: commonAudioOnPressButton,
            icon: const Icon(Icons.home_rounded, size: 25.0),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const HomeScreen(
                          title: 'Hi Notes',
                        )),
                (route) => false,
              );
            },
            coreButtonStyle:
                ThemeDataCenter.getCoreScreenButtonStyle(context: context),
          ),
        )
      ],
      backgroundColor: settingNotifier.isSetBackgroundImage == true
          ? Colors.transparent
          : ThemeDataCenter.getBackgroundColor(context),
      title: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: CommonStyles.titleScreenDecorationStyle(
                    settingNotifier.isSetBackgroundImage),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                          CommonLanguages.convert(
                              lang: settingNotifier.languageString ??
                                  CommonLanguages.languageStringDefault(),
                              word: 'screen.title.settings'),
                          style: CommonStyles.screenTitleTextStyle(
                              color: ThemeDataCenter.getScreenTitleTextColor(
                                  context))),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      titleSpacing: 0,
    );
  }
}
