

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'http_service.dart';

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
  _StationCardState createState() => _StationCardState();
}

class _StationCardState extends State<StationCard> {
  Timetable? _timetable;
  final List<Widget> _destinationList = [];

  @override
  void initState() {
    setTimetable();
    super.initState();
  }

  void setTimetable() async {
    _timetable = await widget.station.getTimetable();
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
        title: Text(widget.station.name),
        trailing:
        ValueListenableBuilder(valueListenable: widget.editing,
            builder: (context, value, child) {
              if(widget.editing.value){
                //show delete button
                return IconButton(onPressed: (){
                  //delete card
                  widget.onDelete(widget);
                },
                  icon: const Icon(Icons.delete), color: Colors.red,);
              } else {
                //hide delete button
                return const Icon(Icons.trip_origin, color: Colors.transparent,);
              }
            }),
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