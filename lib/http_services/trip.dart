import 'package:xml/xml.dart';

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


