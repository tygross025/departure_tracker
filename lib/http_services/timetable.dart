import 'package:departure_tracker/http_services/station.dart';
import 'package:departure_tracker/http_services/trip.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';

import '../auth/api_keys.dart';

class Timetable {
  List<Trip> trips;
  DateTime _timestamp = DateTime.now();
  final Station station;
  final Duration duration;
  Map<String, List<DateTime>> _departureInfo = {};

  Timetable({
    required this.trips,
    required this.station,
    required this.duration,
  });


  static Future<Timetable> fromStation(Station station, [Duration? duration]) async {

    DateTime currentTime = DateTime.now();
    DateTimeRange range = DateTimeRange(start: currentTime, end: currentTime.add((duration == null)? const Duration(hours: 6) : duration));

    List<Trip> trips = await _requestTrips(station, range);

    return Timetable(trips: trips, station: station, duration: (duration == null)? const Duration(hours: 6) : duration);
  }

  //request for trips at station for given hour
  static Future<List<Trip>> _requestTrips(Station station, DateTimeRange timerange) async {
    List<Trip> returnList = [];

    for(int i = 0; i < timerange.duration.inHours + 1; i++){
      //request trips for every hour in timeRange

      //generate time info
      DateTime time = timerange.start.add(Duration(hours: i));
      String iso8601Time = time.toIso8601String(); //yyyy-mm-ddThh:mm:ss.mmmuuuZ format
      String year = iso8601Time.substring(2,4);
      String month = iso8601Time.substring(5,7);
      String day = iso8601Time.substring(8,10);
      String hour = iso8601Time.substring(11,13);

      Uri getTimetableUrl = Uri.parse('https://apis.deutschebahn.com/db-api-marketplace/apis/timetables/v1/plan/${station.id.toString()}/$year$month$day/$hour');
      Map<String, String> headers = {'DB-Client-Id' : dbClientId, 'DB-Api-Key' : dbApiKey};

      //make request
      Response res = await get(getTimetableUrl, headers: headers);

      if(res.statusCode == 200){
        //Successful http request
        XmlDocument xmlDocument = XmlDocument.parse(res.body);
        //add trips for given hour to final list
        returnList.addAll(_tripsFromXml(xmlDocument));
      } else {
        throw "Unable to retrieve stations.";
      }
    }

    return returnList;
  }


  static List<Trip> _tripsFromXml(XmlDocument doc){
    Iterable<XmlElement> trips = doc.findAllElements('s');
    List<Trip> tripList = [];

    //read all trips and add them to list
    for(XmlElement item in trips){
      try {
        Trip trip = Trip.fromXmlElement(item);
        tripList.add(trip);
      } catch(on){
        //trip is invalid and not added to timetable
        continue;
      }
    }

    return tripList;
  }

  Future<Map<String, List<DateTime>>> getDepartureInfo() async { //organize trips into a map with key: destination and value: list of times

    if(_departureInfo.isNotEmpty){
      if(_timestamp.isBefore(DateTime.now().subtract(const Duration(hours: 1)))){
        //update departure info with new timestamp
        _timestamp = DateTime.now();
        DateTimeRange range = DateTimeRange(start: _timestamp, end: _timestamp.add(duration));

        //update trips list with newest info
        trips = await _requestTrips(station, range);
      } else {
        //map is already generated
        return _departureInfo;
      }
    }

    //generate map
    _departureInfo = {};
    for(Trip trip in trips){
      if(trip.plannedDepartureTime.isBefore(DateTime.now())){
        //if trip is in the past dont add it
        continue;
      }

      String routeName = '${trip.category}${trip.lineName} ${trip.plannedDestination}';
      if(_departureInfo.containsKey(routeName)){
        //if destination is already in map add departure time to time list
        List<DateTime>? newDateTime = _departureInfo[routeName];
        if(newDateTime == null){throw Exception("Failed getting departure info.");}
        _departureInfo.remove(routeName);
        newDateTime.add(trip.plannedDepartureTime);
        _departureInfo.addEntries([MapEntry(routeName, newDateTime)]);
      } else {
        //destination not in map so add it as well as time to list
        _departureInfo.addEntries([MapEntry(routeName, [trip.plannedDepartureTime])]);
      }
    }

    //sort departure times for each destination in ascending order
    for (var list in _departureInfo.values) {
      list.sort((a,b) => a.compareTo(b));
    }

    return _departureInfo;
  }
}


