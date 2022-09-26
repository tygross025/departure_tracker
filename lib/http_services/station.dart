import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:departure_tracker/http_services/timetable.dart';
import 'package:http/http.dart';
import '../auth/api_keys.dart';

class Station {
  final int id;
  final String name;

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

  static Future<Station?>  getStation(String pattern) async {
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
}



