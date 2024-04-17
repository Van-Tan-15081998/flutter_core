import 'package:shared_preferences/shared_preferences.dart';

class SettingSharedPreferences {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setIsColorAccordingSubjectColor(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isSetColorAccordingSubjectColor =
        prefs.getBool('isSetColorAccordingSubjectColor');

    await prefs
        .setBool('isSetColorAccordingSubjectColor', isSet)
        .then((bool success) {
      return isSet;
    });
  }

  Future<void> setIsActiveSound(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isActiveSound = prefs.getBool('isActiveSound');

    await prefs.setBool('isActiveSound', isSet).then((bool success) {
      return isSet;
    });
  }

  Future<void> setIsExpandedNoteContent(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedNotContent = prefs.getBool('isExpandedNoteContent');

    await prefs.setBool('isExpandedNoteContent', isSet).then((bool success) {
      return isSet;
    });
  }

  Future<void> setIsExpandedSubjectActions(bool isSet) async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedSubjectActions = prefs.getBool('isExpandedSubjectActions');

    await prefs.setBool('isExpandedSubjectActions', isSet).then((bool success) {
      return isSet;
    });
  }

  Future<bool?> getIsColorAccordingSubjectColor() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isSetColorAccordingSubjectColor =
        prefs.getBool('isSetColorAccordingSubjectColor');

    return isSetColorAccordingSubjectColor;
  }

  Future<bool?> getIsActiveSound() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isActiveSound = prefs.getBool('isActiveSound');

    return isActiveSound;
  }

  Future<bool?> getIsExpandedNoteContent() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedNoteContent = prefs.getBool('isExpandedNoteContent');

    return isExpandedNoteContent;
  }

  Future<bool?> getIsExpandedSubjectActions() async {
    final SharedPreferences prefs = await _prefs;

    final bool? isExpandedSubjectActions = prefs.getBool('isExpandedSubjectActions');

    return isExpandedSubjectActions;
  }
}
