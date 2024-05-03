import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../library/common/languages/CommonLanguages.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../functions/SettingSharedPreferences.dart';

class SettingNotifier with ChangeNotifier {
  bool? _isSetColorAccordingSubjectColor;
  bool? _isStickTitleOfNote;
  bool? _isExpandedNoteContent;
  bool? _isExpandedSubjectActions;
  bool? _isExpandedTemplateContent;
  bool? _isSetBackgroundImage;

  bool? get isSetColorAccordingSubjectColor => _isSetColorAccordingSubjectColor;
  bool? get isStickTitleOfNote => _isStickTitleOfNote;
  bool? get isExpandedNoteContent => _isExpandedNoteContent;
  bool? get isExpandedSubjectActions => _isExpandedSubjectActions;
  bool? get isExpandedTemplateContent => _isExpandedTemplateContent;
  bool? get isSetBackgroundImage => _isSetBackgroundImage;

  String? _themeString;
  String? get themeString => _themeString;

  String? _backgroundImageSourceString;
  String? get backgroundImageSourceString => _backgroundImageSourceString;

  String? _languageString;
  String? get languageString => _languageString;

  String? _avatarDescriptionString;
  String? get avatarDescriptionString => _avatarDescriptionString;

  SettingNotifier() {
    init();
  }

  init() async {
    _themeString = await getThemeString();
    _avatarDescriptionString = await getAvatarDescriptionString();
    _backgroundImageSourceString = await getBackgroundImageSourceString();
    _languageString = await getLanguageString();

    _isSetColorAccordingSubjectColor =
        await getIsSetColorAccordingSubjectColor();

    _isStickTitleOfNote = await getIsStickTitleOfNote();

    _isSetBackgroundImage = await getIsSetBackgroundImage();

    _isExpandedNoteContent = await getIsExpandedNoteContent();

    _isExpandedTemplateContent = await getIsExpandedTemplateContent();

    notifyListeners();
  }

  /*
  GETTER
   */
  Future<bool?> getIsSetColorAccordingSubjectColor() async {
    bool? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getIsColorAccordingSubjectColor();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setIsColorAccordingSubjectColor(false);

      // Get again
      result = await getIsSetColorAccordingSubjectColor();
    }

    return result;
  }

  Future<bool?> getIsStickTitleOfNote() async {
    bool? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getIsStickTitleOfNote();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setIsStickTitleOfNote(false);

      // Get again
      result = await getIsStickTitleOfNote();
    }

    return result;
  }

  Future<bool?> getIsSetBackgroundImage() async {
    bool? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getIsSetBackgroundImage();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setIsSetBackgroundImage(false);

      // Get again
      result = await getIsSetBackgroundImage();
    }

    return result;
  }

  Future<bool?> getIsExpandedNoteContent() async {
    bool? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getIsExpandedNoteContent();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setIsExpandedNoteContent(false);

      // Get again
      result = await getIsExpandedNoteContent();
    }

    return result;
  }

  Future<bool?> getIsExpandedSubjectActions() async {
    bool? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getIsExpandedSubjectActions();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setIsExpandedSubjectActions(false);

      // Get again
      result = await getIsExpandedSubjectActions();
    }

    return result;
  }

  Future<bool?> getIsExpandedTemplateContent() async {
    bool? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getIsExpandedTemplateContent();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setIsExpandedTemplateContent(false);

      // Get again
      result = await getIsExpandedTemplateContent();
    }

    return result;
  }

  Future<String?> getThemeString() async {
    String? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getThemeString();

    if (result == null) {
      // Set default
      await settingSharedPreferences.setThemeString('isSetThemeDefault');

      // Get again
      result = await getThemeString();
    }

    return result;
  }

  Future<String?> getAvatarDescriptionString() async {
    String? result;
    SettingSharedPreferences settingSharedPreferences =
    SettingSharedPreferences();
    result = await settingSharedPreferences.getAvatarDescriptionString();

    if (result == null) {
      // Set default
      await settingSharedPreferences.setAvatarDescriptionString('Hi!, press and hold to change the description');

      // Get again
      result = await getAvatarDescriptionString();
    }

    return result;
  }

  Future<String?> getBackgroundImageSourceString() async {
    String? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getBackgroundImageSourceString();

    if (result == null) {
      // Set default
      await settingSharedPreferences.setBackgroundImageSourceString(
          CommonStyles.backgroundImageSourceStringDefault());

      // Get again
      result = await getBackgroundImageSourceString();
    }

    return result;
  }

  Future<String?> getLanguageString() async {
    String? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getLanguageString();

    if (result == null) {
      // Set default
      await settingSharedPreferences
          .setLanguageString(CommonLanguages.languageStringDefault());

      // Get again
      result = await getLanguageString();
    }

    return result;
  }

  /*
  SETTER
   */

  Future<bool> setIsSetColorAccordingSubjectColor(bool isSet) async {
    bool? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setIsColorAccordingSubjectColor(isSet);

    result = await settingSharedPreferences.getIsColorAccordingSubjectColor();

    if (result != null) {
      _isSetColorAccordingSubjectColor = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setIsStickTitleOfNote(bool isSet) async {
    bool? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setIsStickTitleOfNote(isSet);

    result = await settingSharedPreferences.getIsStickTitleOfNote();

    if (result != null) {
      _isStickTitleOfNote = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setIsSetBackgroundImage(bool isSet) async {
    bool? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setIsSetBackgroundImage(isSet);

    result = await settingSharedPreferences.getIsSetBackgroundImage();

    if (result != null) {
      _isSetBackgroundImage = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setIsExpandedNoteContent(bool isSet) async {
    bool? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setIsExpandedNoteContent(isSet);

    result = await settingSharedPreferences.getIsExpandedNoteContent();

    if (result != null) {
      _isExpandedNoteContent = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setIsExpandedSubjectActions(bool isSet) async {
    bool? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setIsExpandedSubjectActions(isSet);

    result = await settingSharedPreferences.getIsExpandedSubjectActions();

    if (result != null) {
      _isExpandedSubjectActions = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setIsExpandedTemplateContent(bool isSet) async {
    bool? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setIsExpandedTemplateContent(isSet);

    result = await settingSharedPreferences.getIsExpandedTemplateContent();

    if (result != null) {
      _isExpandedTemplateContent = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setThemeString(String themeStr) async {
    String? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setThemeString(themeStr);

    result = await settingSharedPreferences.getThemeString();

    if (result != null) {
      _themeString = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setAvatarDescription(String avatarDescriptionString) async {
    String? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
    SettingSharedPreferences();
    await settingSharedPreferences.setAvatarDescriptionString(avatarDescriptionString);

    result = await settingSharedPreferences.getAvatarDescriptionString();

    if (result != null) {
      _avatarDescriptionString = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setBackgroundImageSourceString(
      String backgroundImageSourceStr) async {
    String? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences
        .setBackgroundImageSourceString(backgroundImageSourceStr);

    result = await settingSharedPreferences.getBackgroundImageSourceString();

    if (result != null) {
      _backgroundImageSourceString = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setLanguageString(String languageStr) async {
    String? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setLanguageString(languageStr);

    result = await settingSharedPreferences.getLanguageString();

    if (result != null) {
      _languageString = result;
      notifyListeners();

      return true;
    }
    return false;
  }
}
