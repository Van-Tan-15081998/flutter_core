import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../functions/SettingSharedPreferences.dart';

class SettingNotifier with ChangeNotifier {
  bool? _isSetColorAccordingSubjectColor;
  bool? _isActiveSound;
  bool? _isExpandedNoteContent;
  bool? _isExpandedSubjectActions;

  bool? get isSetColorAccordingSubjectColor => _isSetColorAccordingSubjectColor;
  bool? get isActiveSound => _isActiveSound;
  bool? get isExpandedNoteContent => _isExpandedNoteContent;
  bool? get isExpandedSubjectActions => _isExpandedSubjectActions;

  SettingNotifier() {
    init();
  }

  init() async {
    _isSetColorAccordingSubjectColor =
        await getIsSetColorAccordingSubjectColor();

    _isActiveSound = await getIsActiveSound();

    _isExpandedNoteContent = await getIsExpandedNoteContent();

    notifyListeners();
  }

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

  Future<bool?> getIsActiveSound() async {
    bool? result;
    SettingSharedPreferences settingSharedPreferences =
    SettingSharedPreferences();
    result = await settingSharedPreferences.getIsActiveSound();

    if (result == null) {
      // Set false
      await settingSharedPreferences.setIsActiveSound(false);

      // Get again
      result = await getIsActiveSound();
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

  Future<bool> setIsActiveSound(bool isSet) async {
    bool? result;

    // Set
    SettingSharedPreferences settingSharedPreferences =
    SettingSharedPreferences();
    await settingSharedPreferences.setIsActiveSound(isSet);

    result = await settingSharedPreferences.getIsActiveSound();

    if (result != null) {
      _isActiveSound = result;
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
}
