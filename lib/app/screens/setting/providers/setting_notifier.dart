import 'dart:io';

import 'package:flutter/material.dart';
import '../../../library/common/converters/CommonConverters.dart';
import '../../../library/common/languages/CommonLanguages.dart';
import '../../../library/common/styles/CommonStyles.dart';
import '../../../library/common/utils/CommonAudioBackground.dart';
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

  String? _avatarImageSourceString;
  String? get avatarImageSourceString => _avatarImageSourceString;

  String? _playingBackgroundMusicSourceString;
  String? get playingBackgroundMusicSourceString =>
      _playingBackgroundMusicSourceString;

  double? _opacityNumber;
  double? get opacityNumber => _opacityNumber;

  SettingNotifier() {
    init();
  }

  init() async {
    _themeString = await getThemeString();
    _avatarDescriptionString = await getAvatarDescriptionString();
    _avatarImageSourceString = await getAvatarImageSourceString();
    _backgroundImageSourceString = await getBackgroundImageSourceString();
    _languageString = await getLanguageString();
    _playingBackgroundMusicSourceString =
        await getPlayingBackgroundMusicSourceString();

    _isSetColorAccordingSubjectColor =
        await getIsSetColorAccordingSubjectColor();

    _isStickTitleOfNote = await getIsStickTitleOfNote();

    _isSetBackgroundImage = await getIsSetBackgroundImage();

    _isExpandedNoteContent = await getIsExpandedNoteContent();

    _isExpandedTemplateContent = await getIsExpandedTemplateContent();

    _opacityNumber = await getOpacityNumber();

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

  Future<double?> getOpacityNumber() async {
    double? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getOpacityNumber();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setOpacityNumber(1);

      // Get again
      result = await getOpacityNumber();
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
      await settingSharedPreferences.setAvatarDescriptionString(
          'Hi!, press and hold to change the description');

      // Get again
      result = await getAvatarDescriptionString();
    }

    return result;
  }

  Future<String?> getAvatarImageSourceString() async {
    String? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result = await settingSharedPreferences.getAvatarImageSourceString();

    if (result == null) {
      // Set default
      await settingSharedPreferences.setAvatarImageSourceString('');

      // Get again
      result = await getAvatarImageSourceString();
    }

    if (result != null && result.isNotEmpty) {
      bool isExist = await File(result).exists();

      if (!isExist) {
        await settingSharedPreferences.setAvatarImageSourceString('');

        result = await getAvatarImageSourceString();
      }
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

  Future<String?> getPlayingBackgroundMusicSourceString() async {
    String? result;
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    result =
        await settingSharedPreferences.getPlayingBackgroundMusicSourceString();

    if (result == null) {
      // Set default
      await settingSharedPreferences
          .setPlayingBackgroundMusicSourceString("ALL");

      // Get again
      result = await getPlayingBackgroundMusicSourceString();
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
    await settingSharedPreferences
        .setAvatarDescriptionString(avatarDescriptionString);

    result = await settingSharedPreferences.getAvatarDescriptionString();

    if (result != null) {
      _avatarDescriptionString = result;
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> setAvatarImageSourceString(
      String avatarImageSourceString) async {
    String? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences
        .setAvatarImageSourceString(avatarImageSourceString);

    result = await settingSharedPreferences.getAvatarImageSourceString();

    if (result != null) {
      _avatarImageSourceString = result;
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

  Future<bool> setPlayingBackgroundMusicSourceString(
      String playingBackgroundMusicSourceStr) async {
    String? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences
        .setPlayingBackgroundMusicSourceString(playingBackgroundMusicSourceStr);

    result =
        await settingSharedPreferences.getPlayingBackgroundMusicSourceString();

    if (result != null) {
      _playingBackgroundMusicSourceString = result;
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

  Future<bool> setOpacityNumber(double opacityNum) async {
    double? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
        SettingSharedPreferences();
    await settingSharedPreferences.setOpacityNumber(opacityNum);

    result = await settingSharedPreferences.getOpacityNumber();

    if (result != null) {
      _opacityNumber = result;
      notifyListeners();

      return true;
    }
    return false;
  }
}
