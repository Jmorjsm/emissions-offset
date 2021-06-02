import 'dart:convert';

import 'package:emissions_offset/models/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class AppSettingsStore with ChangeNotifier {
  AppSettings appSettings;

  static const String _appSettingsFileName = 'emissions-offset-app-settings';
  static const String _appSettingsItemName = "app-settings";

  final LocalStorage storage = new LocalStorage(_appSettingsFileName);

  AppSettingsStore() {
    storage.ready.then((_) => loadAppSettings());
  }

  // Save the app settings to local storage
  saveSettings(AppSettings appSettings){
    this.appSettings = appSettings;
    this.storage.setItem(_appSettingsItemName, this.appSettings.toJson());
    notifyListeners();
  }

  // Load the app settings from local storage
  loadAppSettings() {
    var appSettingsJson = storage.getItem(_appSettingsItemName);
    if (appSettingsJson != null) {
      debugPrint("settings:");
      debugPrint(appSettingsJson.toString());
      debugPrint("loaded saved trips:");

      this.appSettings = AppSettings.fromJson(appSettingsJson);

      if (this.appSettings != null) {
        debugPrint(this.appSettings.toString());
      }
    } else {
      debugPrint("no saved appSettings file...");
      this.appSettings = new AppSettings();
    }
    // Tell the ui that we're done loading.
    notifyListeners();
  }
}