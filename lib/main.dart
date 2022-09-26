import 'package:departure_tracker/settings_screen.dart';
import 'package:departure_tracker/station_card.dart';
import 'package:departure_tracker/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_station_screen.dart';
import 'http_services/station.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  await themeProvider.init();
  runApp(MyApp(themeProvider: themeProvider,));
}


class MyApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const MyApp({super.key, required this.themeProvider,});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeProvider>(
      create: (_) => themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => const MaterialAppWithTheme(),
      ),
    );
  }
}

class MaterialAppWithTheme extends StatelessWidget {
  const MaterialAppWithTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      home: const MainPage(),
      theme: theme.getTheme(),
    );
  }
}


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<StationCard> _cards = <StationCard>[];
  final _editingCards = ValueNotifier<bool>(false);

  @override
  void initState() {
    _loadStationCards();
    super.initState();
  }


  _loadStationCards() async {
    //load station list from sharedPrefs
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stations = prefs.getStringList('stationList');
    if(stations != null){
      for(String statonString in stations){
        _cards.add(
          StationCard(station: Station.fromString(statonString), editing: _editingCards, onDelete: _onDelete,),
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Departures'),
              centerTitle: true,
              floating: false,
              actions:  [
                IconButton(onPressed: () {
                  if(_editingCards.value){
                    setState(() {
                      _editingCards.value = false;
                    });
                  } else {
                    //open bottom sheet for app options
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                //if editing display exit button, otherwise show menu
                                leading: const Icon(Icons.edit),
                                title: const Text('Edit cards'),
                                onTap: (){
                                  _enterEditMode();
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.settings),
                                title: const Text('App settings'),
                                onTap: (){
                                  //close Bottom sheet
                                  Navigator.pop(context);
                                  //launch settings page
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) =>
                                      const SettingsScreen()
                                    )
                                  );
                                },
                              ),
                            ],
                          );
                        });
                  }
                },
                    //if in card edit mode show exit button
                    icon: (_editingCards.value)?  const ElevatedButton(
                        onPressed: null, child: Text('Exit Edit Mode', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),))
                        //else show menu button
                        : const Icon(Icons.more_horiz),
                ),
              ],
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                    return _cards[index];
                  },
                  childCount: _cards.length,
                ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //navigate to create new station page
          _launchAddStationScreen(context);
        },
        tooltip: 'Add Station',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _launchAddStationScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddStationScreen(cards: _cards),
      ),
    );

    if(!mounted) return;

    if(result is Station){
      setState(() {
        _cards.add(
          StationCard(station: result, editing: _editingCards, onDelete: _onDelete,),
        );
      });
    }
  }

  _onDelete(StationCard card) async {
    //remove card from list
    setState(() {
      _cards.remove(card);
    });
    //delete card from prefs
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stations = prefs.getStringList('stationList');
    if(stations != null){
      stations.remove('${card.station.name}|${card.station.id}');
      await prefs.setStringList('stationList', stations);
    }
  }

  _enterEditMode(){
    setState(() {
      _editingCards.value = true; //Set cards to editmode state
    });
    Navigator.pop(context); //close BottomSheet

  }
}





