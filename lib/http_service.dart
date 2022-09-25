import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'auth/api_keys.dart';



Future<Station?> getStation(String pattern) async {
  Uri getStationsUrl = Uri.parse("https://apis.deutschebahn.com/db-api-marketplace/apis/timetables/v1/station/$pattern");
  Map<String, String> headers = {'DB-Client-Id' : dbClientId, 'DB-Api-Key' : dbApiKey};
  Response res = await get(getStationsUrl, headers: headers);
  final prefs = await SharedPreferences.getInstance();

  if(res.statusCode == 200){
    //Successful http request
    XmlDocument xmlDocument = XmlDocument.parse(res.body);

    try {
      Station station = Station.fromXml(xmlDocument);

      //save station id locally as 'station name'|'id number'
      List<String>? stationList = prefs.getStringList('stationList'); //read current station list
      stationList ??= []; //station list does not yet exist and must be initialized.
      stationList.add('${station.name}|${station.id}');
      await prefs.setStringList('stationList', stationList); //save new list

      return station;
    } catch(on) {
      return null;
    }
  } else {
    throw "Unable to retrieve stations.";
  }
}



class Timetable {
  final List<Trip> trips;
  Map<String, List<DateTime>> _departureInfo = {};

  Timetable({
    required this.trips,
  });

  factory Timetable.fromXml(XmlDocument doc){
    Iterable<XmlElement> trips = doc.findAllElements('s');
    List<Trip> tripList = [];

    for(XmlElement item in trips){
      try {
        Trip trip = Trip.fromXmlElement(item);
        tripList.add(trip);
      } catch(on){
        //trip is invalid and not added to timetable
        continue;
      }
    }

    return Timetable(trips: tripList);
  }

  Map<String, List<DateTime>> getDepartureInfo(){ //organize trips into a map with key: destination and value: list of times

    if(_departureInfo.isNotEmpty){ //if map is already generated return it
      return _departureInfo;
    }
    //generate map
    _departureInfo = {};
    for(Trip trip in trips){
      if(trip.plannedDepartureTime.isBefore(DateTime.now())){
        //if trip is in the past dont add it
        continue;
      }

      if(_departureInfo.containsKey(trip.plannedDestination)){
        //if destination is already in map add departure time to time list
        List<DateTime>? newDateTime = _departureInfo[trip.plannedDestination];
        if(newDateTime == null){throw Exception("Failed getting departure info.");}
        _departureInfo.remove(trip.plannedDestination);
        newDateTime.add(trip.plannedDepartureTime);
        _departureInfo.addEntries([MapEntry(trip.plannedDestination, newDateTime)]);
      } else {
        //destination not in map so add it as well as time to list
        _departureInfo.addEntries([MapEntry('${trip.category}${trip.lineName} ${trip.plannedDestination}', [trip.plannedDepartureTime])]);
      }
    }

    //sort departure times for each destination in ascending order
    for (var list in _departureInfo.values) {
      list.sort((a,b) => a.compareTo(b));
    }

    return _departureInfo;
  }
}


class Trip {
  final DateTime plannedDepartureTime;
  final String plannedDestination;
  final String lineName;
  final String plannedPlatform;
  final String category;

  const Trip({
    required this.plannedDepartureTime,
    required this.plannedDestination,
    required this.lineName,
    required this.plannedPlatform,
    required this.category,
  });

  factory Trip.fromXmlElement(XmlElement element){
    String? category = element.getElement('tl')?.getAttribute('c');
    String? lineName = element.getElement('dp')?.getAttribute('l');
    String? plannedPlatform = element.getElement('dp')?.getAttribute('pp');
    String? dateString = element.getElement('dp')?.getAttribute('pt');
    String? plannedDestination = element.getElement('dp')?.getAttribute('ppth');
    
    if(category ==null || lineName == null || plannedPlatform == null || dateString == null|| plannedDestination == null){
      throw Exception('Invalid trip.');
    }

    //convert dateString to DateTime
    DateTime plannedDepTime = DateTime(
      int.parse('20${dateString.substring(0,2)}'), //year
      int.parse(dateString.substring(2,4)), //month
      int.parse(dateString.substring(4,6)), //day
      int.parse(dateString.substring(6,8)), //hour
      int.parse(dateString.substring(8,10)),//min
    );
    
    //Find last station in next station list
    plannedDestination = plannedDestination.substring(plannedDestination.lastIndexOf('|') + 1);
    
    return Trip(lineName: lineName, plannedPlatform: plannedPlatform, category: category, plannedDepartureTime: plannedDepTime, plannedDestination: plannedDestination);
  }
}


class Station {
  final int id;
  final String name;
  Timetable? _timetable;

  Station({
    required this.id,
    required this.name,
  });

  factory Station.fromString(String station){
    //takes input 'station name'|'station id' to create station
    return Station(
        id: int.parse(station.substring(station.indexOf('|')+1)),
        name: station.substring(0, station.indexOf('|'))
    );
  }

  factory Station.fromXml(XmlDocument doc){
    //check if a station is returned
    if(doc.findAllElements('station').isEmpty){
      throw Exception('No Stations Available');
    }

    String? name = doc.findAllElements('station').first.getAttribute('name');
    String? id = doc.findAllElements('station').first.getAttribute('eva');

    if(name != null && id != null){
      return Station(
          name: name,
          id: int.parse(id),
      );
    }
    throw Exception('No Stations Available');
  }

  Future<Timetable?> getTimetable() async {
    if(_timetable != null){
      //Check if timetable already exist to prevent unnecessary api calls
      return _timetable;
    }
    //generate timetable
    DateTime time = DateTime.now();
    String iso8601Time = time.toIso8601String(); //yyyy-mm-ddThh:mm:ss.mmmuuuZ format
    String year = iso8601Time.substring(2,4);
    String month = iso8601Time.substring(5,7);
    String day = iso8601Time.substring(8,10);
    String hour = iso8601Time.substring(11,13);
    Uri getTimetableUrl = Uri.parse('https://apis.deutschebahn.com/db-api-marketplace/apis/timetables/v1/plan/${id.toString()}/$year$month$day/$hour');
    Map<String, String> headers = {'DB-Client-Id' : dbClientId, 'DB-Api-Key' : dbApiKey};
    Response res = await get(getTimetableUrl, headers: headers);


    if(res.statusCode == 200){
      //Successful http request
      XmlDocument xmlDocument = XmlDocument.parse(res.body);

      try {
        _timetable = Timetable.fromXml(xmlDocument);
        return _timetable;
      } catch(on) {
        return null;
      }
    } else {
      throw "Unable to retrieve stations.";
    }
  }
}