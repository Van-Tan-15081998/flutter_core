import 'package:shared_preferences/shared_preferences.dart';

class SettingSharedPreferences {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /*
  SETTER
   */
  Future<void> setIsColorAccordingSubjectColor(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isSetColorAccordingSubjectColor =
        prefs.getBool('isSetColorAccordingSubjectColor');

    await prefs.setBool('isSetColorAccordingSubjectColor', isSet);
  }

  Future<void> setIsStickTitleOfNote(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isStickTitleOfNote = prefs.getBool('isStickTitleOfNote');

    await prefs.setBool('isStickTitleOfNote', isSet);
  }

  Future<void> setIsSetBackgroundImage(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isSetBackgroundImage = prefs.getBool('isSetBackgroundImage');

    await prefs.setBool('isSetBackgroundImage', isSet);
  }

  Future<void> setIsExpandedNoteContent(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedNoteContent = prefs.getBool('isExpandedNoteContent');

    await prefs.setBool('isExpandedNoteContent', isSet);
  }

  Future<void> setIsExpandedSubjectActions(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedSubjectActions =
        prefs.getBool('isExpandedSubjectActions');

    await prefs.setBool('isExpandedSubjectActions', isSet);
  }

  Future<void> setIsExpandedTemplateContent(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedTemplateContent =
        prefs.getBool('isExpandedTemplateContent');

    await prefs.setBool('isExpandedTemplateContent', isSet);
  }

  /*
  SETTER THEMES
  - Default  (isSetThemeDefault)
  - Black and White  (isSetThemeBlackAndWhite)
  - Beach Towels  (isSetThemeBeachTowels) #fe4a49 • #2ab7ca • #fed766 • #e6e6ea • #f4f4f8
  - Beautiful Blues  (isSetThemeBeautifulBlues) #011f4b • #03396c • #005b96 • #6497b1 • #b3cde0
  - Moonlight Bytes  (isSetThemeMoonlightBytes) #4a4e4d • #0e9aa7 • #3da4ab • #f6cd61 • #fe8a71
  - Number 3  (isSetThemeNumber3) #2a4d69 • #4b86b4 • #adcbe3 • #e7eff6 • #63ace5
  - Android Lollipop  (isSetThemeAndroidLollipop) #009688 • #35a79c • #54b2a9 • #65c3ba • #83d0c9
  - Rainbow Dash  (isSetThemeRainbowDash) #ee4035 • #f37736 • #fdf498 • #7bc043 • #0392cf
  - Shades of White  (isSetThemeShadesOfWhite) #faf0e6 • #fff5ee • #fdf5e6 • #faf0e6 • #faebd7
  - Blueberry Basket  (isSetThemeBlueberryBasket) #ffffff • #d0e1f9 • #4d648d • #283655 • #1e1f26
  - Five Shades of Grey  (isSetThemeFiveShadesOfGrey) #eeeeee • #dddddd • #cccccc • #bbbbbb • #aaaaaa
  - Beach  (isSetThemeBeach) #96ceb4 • #ffeead • #ff6f69 • #ffcc5c • #88d8b0
  - Cappuccino  (isSetThemeCappuccino) #4b3832 • #854442 • #fff4e6 • #3c2f2f • #be9b7b
  - Grey Lavender Colors  (isSetThemeGreyLavenderColors) #d2d4dc • #afafaf • #f8f8fa • #e5e6eb • #c0c2ce
  - Metro UI Colors  (isSetThemeMetroUIColors) #d11141 • #00b159 • #00aedb • #f37735 • #ffc425
  - Pinks  (isSetThemePinks) #ff77aa • #ff99cc • #ffbbee • #ff5588 • #ff3377
  - Never Doubt  (isSetThemeNeverDoubt) #eeeeee • #dddddd • #cccccc • #bbbbbb • #29a8ab
  - Program Catalog  (isSetThemeProgramCatalog) #edc951 • #eb6841 • #cc2a36 • #4f372d • #00a0b0
   */
  Future<void> setThemeString(String themeStr) async {
    final SharedPreferences prefs = await _prefs;

    final String? themeString = prefs.getString('themeString');

    await prefs.setString('themeString', themeStr);
  }

  Future<void> setAvatarDescriptionString(String avatarDescriptionStr) async {
    final SharedPreferences prefs = await _prefs;

    final String? avatarDescriptionString = prefs.getString('avatarDescriptionString');

    await prefs.setString('avatarDescriptionString', avatarDescriptionStr);
  }

  Future<void> setBackgroundImageSourceString(
      String backgroundImageSourceStr) async {
    final SharedPreferences prefs = await _prefs;

    final String? backgroundImageSourceString =
        prefs.getString('backgroundImageSourceString');

    await prefs.setString(
        'backgroundImageSourceString', backgroundImageSourceStr);
  }

  Future<void> setLanguageString(String languageStr) async {
    final SharedPreferences prefs = await _prefs;

    final String? languageString = prefs.getString('languageString');

    await prefs.setString('languageString', languageStr);
  }

/*
GETTER
 */

  Future<bool?> getIsColorAccordingSubjectColor() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isSetColorAccordingSubjectColor =
        prefs.getBool('isSetColorAccordingSubjectColor');

    return isSetColorAccordingSubjectColor;
  }

  Future<bool?> getIsStickTitleOfNote() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isStickTitleOfNote = prefs.getBool('isStickTitleOfNote');

    return isStickTitleOfNote;
  }

  Future<bool?> getIsSetBackgroundImage() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isSetBackgroundImage = prefs.getBool('isSetBackgroundImage');

    return isSetBackgroundImage;
  }

  Future<bool?> getIsExpandedNoteContent() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedNoteContent = prefs.getBool('isExpandedNoteContent');

    return isExpandedNoteContent;
  }

  Future<bool?> getIsExpandedSubjectActions() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedSubjectActions =
        prefs.getBool('isExpandedSubjectActions');

    return isExpandedSubjectActions;
  }

  Future<bool?> getIsExpandedTemplateContent() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedTemplateContent =
        prefs.getBool('isExpandedTemplateContent');

    return isExpandedTemplateContent;
  }

  Future<String?> getThemeString() async {
    final SharedPreferences prefs = await _prefs;

    final String? themeString = prefs.getString('themeString');

    return themeString;
  }

  Future<String?> getAvatarDescriptionString() async {
    final SharedPreferences prefs = await _prefs;

    final String? avatarDescriptionString = prefs.getString('avatarDescriptionString');

    return avatarDescriptionString;
  }

  Future<String?> getBackgroundImageSourceString() async {
    final SharedPreferences prefs = await _prefs;

    final String? backgroundImageSourceString =
        prefs.getString('backgroundImageSourceString');

    return backgroundImageSourceString;
  }

  Future<String?> getLanguageString() async {
    final SharedPreferences prefs = await _prefs;

    final String? languageString = prefs.getString('languageString');

    return languageString;
  }
}
