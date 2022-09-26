import 'package:flutter/material.dart';
import 'http_services/station.dart';
import 'http_services/timetable.dart';

class StationCard extends StatefulWidget {
  final Station station;
  final ValueNotifier<bool> editing;
  final Function onDelete;

  const StationCard({
    Key? key,
    required this.station,
    required this.editing,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<StationCard> createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  final List<Widget> _destinationList = [];

  Future<Map<String, List<DateTime>>> _getTimetableMap() async {
    Timetable timetable = await Timetable.fromStation(widget.station);
    Map<String, List<DateTime>> departures = await timetable.getDepartureInfo();
    return departures;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getTimetableMap(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //display loading animation in card
            return Card(
              child: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
            );
          } else {
            if (snapshot.hasError) {
              return const Card(
                child: Text('Could not retrieve station information'),
              );
            } else {
              final timetable = snapshot.data;
              if (timetable != null) {
                for (MapEntry entry in timetable.entries) {
                  //show end station followed by next departure time
                  _destinationList.add(ListTile(
                    subtitle: Text(entry.key),
                    trailing: Text(
                        entry.value[0].toIso8601String().substring(11, 16)),
                  ));
                }
              }
              List<Widget> columnChildren = [
                ListTile(
                  title: Text(widget.station.name),
                  trailing: ValueListenableBuilder(
                      valueListenable: widget.editing,
                      builder: (context, value, child) {
                        if (widget.editing.value) {
                          //show delete button
                          return IconButton(
                            onPressed: () {
                              //delete card
                              widget.onDelete(widget);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          );
                        } else {
                          //hide delete button
                          return const Icon(
                            Icons.trip_origin,
                            color: Colors.transparent,
                          );
                        }
                      }),
                ),
              ];

              //only display first 4 destinations on card
              for (int i = 0; i < _destinationList.length && i < 4; i++) {
                columnChildren.add(_destinationList[i]);
              }

              //add expand option if needed
              if (_destinationList.length > 4) {
                columnChildren.add(const Divider());
                columnChildren.add(
                  TextButton(
                      onPressed: () {
                        //open full screen card
                        Navigator.of(context).push(_createRoute());
                      },
                      child: const Text('more')),
                );
              }

              return Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: columnChildren,
                ),
              );
            }
          }
        });
  }

  //slide up animation for extending card
  Route _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FullScreenCard(
              station: widget.station,
            ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }
}

class FullScreenCard extends StatefulWidget {
  const FullScreenCard({Key? key, required this.station}) : super(key: key);
  final Station station;

  @override
  State<FullScreenCard> createState() => _FullScreenCardState();
}

class _FullScreenCardState extends State<FullScreenCard> {
  List<Widget> _destinationList = [];

  Future<Map<String, List<DateTime>>> _getTimetableMap() async {
    Timetable timetable = await Timetable.fromStation(widget.station);
    Map<String, List<DateTime>> departures = await timetable.getDepartureInfo();
    return departures;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getTimetableMap(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            //todo loading animation
            _destinationList = [
              const Text('loading..'),
            ];
          } else {
            if (snapshot.hasError) {
              _destinationList = [
                const Text('Unable to retrieve timetable'),
              ];
            } else {
              final timetable = snapshot.data;
              _destinationList = [];
              if (timetable != null) {
                //add all destination entries into list
                for (MapEntry entry in timetable.entries) {
                  String timesString = '';
                  for (DateTime time in entry.value) {
                    timesString =
                        '$timesString${time.toIso8601String().substring(11, 16)}   ';
                  }

                  _destinationList.add(ListTile(
                    title: Text(entry.key), //destination name
                    //entry.value[0].toIso8601String().substring(11,16)
                    subtitle: Text(timesString),
                  ));
                }
              }
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.station.name),
              centerTitle: true,
            ),
            body: ListView(
              children:
                  _destinationList, //display error or list of destinations
            ),
          );
        });
  }
}
