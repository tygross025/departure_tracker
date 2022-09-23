import 'package:departure_tracker/theme/color_schemes.dart';
import 'package:departure_tracker/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('Settings'),
              floating: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const ThemeSelection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ThemeSelection extends StatefulWidget {
  const ThemeSelection({Key? key}) : super(key: key);

  @override
  _ThemeSelectionState createState() => _ThemeSelectionState();
}

class _ThemeSelectionState extends State<ThemeSelection> {
  List<bool>? _selectedDarkMode;

  _setTheme(BuildContext context, List<bool> darkMode, int color){
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    if(darkMode[0]){ //light mode
      themeProvider.setAppTheme(1, color);
    } else if(darkMode[1]){ //dark mode
      themeProvider.setAppTheme(2, color);
    } else { //use system mode
      var brightness = MediaQuery.of(context).platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;
      themeProvider.setAppTheme(3, color, isDarkMode);
    }
  }

  @override
  void initState() {
    _getSharedPrefs();
    super.initState();
  }

  Future<void> _getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    int? darkModeSetting = prefs.getInt('darkModeSetting');
    setState(() {
      switch(darkModeSetting){
        case 1: _selectedDarkMode = <bool>[true, false, false]; break;
        case 2: _selectedDarkMode = <bool>[false, true, false]; break;
        case 3: _selectedDarkMode = <bool>[false, false, true]; break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    int selectedColor = 1;

    _selectedDarkMode ??= <bool>[false,false,false];


    return Card(
      child: Column(
        children: [
          const ListTile(
            title: Text('App Color Scheme'),
          ),
          ToggleButtons(
            borderRadius: BorderRadius.circular(100), //rounded Corners
            direction: Axis.horizontal,
            constraints: const BoxConstraints(
              minHeight: 40,
              minWidth: 100,
            ),
            onPressed: (index) {
              //Set selected Button to true and others to false
              setState(() {
                for(int i = 0; i < _selectedDarkMode!.length; i++){
                  _selectedDarkMode![i] = i == index;
                }
                _setTheme(context, _selectedDarkMode!, selectedColor); //apply changes to theme
              });
            },
            isSelected: _selectedDarkMode!,
            children: const [
              Text('Light'),
              Text('Dark'),
              Text('System'),
            ],
          ),
          Row(
            children: [
              IconButton(
                iconSize: 50,
                icon: const Icon(
                  Icons.circle,
                  color: AppColorTheme.green,
                ),
                onPressed: () {
                  _setTheme(context, _selectedDarkMode!, 1);
                },
              ),
              IconButton(
                iconSize: 50,
                icon: const Icon(
                  Icons.circle,
                  color: AppColorTheme.red,
                ),
                onPressed: () {
                  _setTheme(context, _selectedDarkMode!, 2);
                },
              ),
              IconButton(
                iconSize: 50,
                icon: const Icon(
                  Icons.circle,
                  color: AppColorTheme.blue,
                ),
                onPressed: () {
                  _setTheme(context, _selectedDarkMode!, 3);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
