import 'package:http/http.dart' as http;
import 'dart:convert';

class Location {
  String name;
  String taluk;
  String district;
  String state;
 
  Location(this.name, this.taluk, this.district, this.state);
 
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        json['Name'], json['Taluk'], json['District'], json['State']);
  }


}

 
  Future<Location> getLocation(pincode) async {
  final response = await http.get(Uri.parse("http://www.postalpincode.in/api/pincode/$pincode"));
  
  if (response.statusCode >= 200 && response.statusCode < 400) {
    final json = jsonDecode(response.body);
    //print("Viru: $json");
    return Location.fromJson(json['PostOffice'][0]);
  } else {
    throw Exception("Error while fetching data");
  }
}