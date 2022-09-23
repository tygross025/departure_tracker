import 'package:departure_tracker/theme/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier{
  ThemeData? _selectedTheme;

  ThemeProvider();

  Future<void> init() async {
    //load shared prefs
    final prefs = await SharedPreferences.getInstance();
    final darkModeSetting = prefs.getInt('darkModeSetting') ?? 3; //if null default to system dark mode
    final colorOption = prefs.getInt('themeColorOption') ?? 2;// default to red colorscheme

    if(darkModeSetting == 3){
      //read system dark mode setting
      var brightness = SchedulerBinding.instance.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      //set theme
      setAppTheme(darkModeSetting, colorOption, isDarkMode);
    } else {
      //set theme
      setAppTheme(darkModeSetting, colorOption);
    }

    notifyListeners();
  }

  getTheme() => _selectedTheme;

  setAppTheme(int darkModeSetting, int colorOption, [bool isSystemDark = false]) async {
    //set theme
    bool isDark;
    if(darkModeSetting == 1) {
      isDark = false;
    } else if(darkModeSetting == 2){
      isDark = true;
    } else {
      isDark = isSystemDark;
    }
    _selectedTheme = ThemeData(useMaterial3: true, colorScheme: AppColorTheme.getAppTheme(isDark, colorOption));

    //save theme
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('darkModeSetting', darkModeSetting);
    await prefs.setInt('themeColorOption', colorOption);

    notifyListeners();
  }
}
