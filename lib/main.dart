import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_station_screen.dart';
import 'http_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Departure Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  List<Widget> _cards = <Widget>[];

  @override
  void initState() {
    _loadStationCards();
    super.initState();
  }

  _loadStationCards() async {
    //load station list from sharedPrefs
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stations = prefs.getStringList('stationList');
    for(String statonString in stations!){
      _cards.add(
        StationCard(station: Station.fromString(statonString)),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              actions:  [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
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
          StationCard(station: result,),
        );
      });
    }
  }
}

class StationCard extends StatefulWidget {
  final Station station;
  const StationCard({Key? key, required this.station}) : super(key: key);

  @override
  _StationCardState createState() => _StationCardState(station: station);
}

class _StationCardState extends State<StationCard> {
  final Station station;
  Timetable? _timetable;
  final List<Widget> _destinationList = [];

  _StationCardState({required this.station});

  @override
  void initState() {
    setTimetable();
    super.initState();
  }

  void setTimetable() async {
    _timetable = await station.getTimetable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final timetable = _timetable;
    if(timetable != null){
      for(MapEntry entry in timetable.getDepartureInfo().entries){
        String depTimes = '';
        //concatenate departure time strings together
        for(DateTime time in entry.value){
          depTimes = '$depTimes${time.toIso8601String().substring(11,16)} ';
        }
        _destinationList.add(ListTile(
          subtitle: Text(entry.key),
          trailing: Text(depTimes),
        ));
      }
    }

    List<Widget> columnChildren  = [
        ListTile(
          title: Text(station.name),
          //trailing: const Icon(Icons.more_vert),
        ),
    ];
    columnChildren.addAll(_destinationList);

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: columnChildren,
      ),
    );
  }
}



