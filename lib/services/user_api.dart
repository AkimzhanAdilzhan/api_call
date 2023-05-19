import 'dart:convert';
import 'package:api_call/model/user.dart';
import 'package:api_call/model/user_dob.dart';
import 'package:api_call/model/user_location.dart';
import 'package:http/http.dart' as http;
import 'package:api_call/model/user_name.dart';

class UserApi {
  static Future<List<User>> fetchUsers() async {
    print('fetchUsers called');
    const url = 'https://randomuser.me/api/?results=100';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['results'] as List<dynamic>;

    final users = results.map(
      (e) {
        final name = UserName(
          title: e['name']['title'],
          first: e['name']['first'],
          last: e['name']['last'],
        );
        final date = e['dob']['date'];
        final dob = UserDob(
          age: e['dob']['age'],
          date: DateTime.parse(date),
        );
        final street = LocationStreet(
          name: e['location']['coordinates']['name'],
          number: e['location']['coordinates']['number'],
        );
        final coordinates = LocationCoordinates(
          latitude: e['location']['coordinates']['latitude'],
          longitube: e['location']['coordinates']['longitube'],
        );
        final timezone = LocationTimezoneCoordinate(
          offset: e['location']['coordinates']['offset'],
          description: e['location']['coordinates']['description'],
        );
        final location = UserLocation(
          city: e['location']['city'],
          coordinates: coordinates,
          country: e['location']['country'],
          postcode: e['location']['postcode'].toString(),
          state: e['location']['state'],
          street: street,
          timezone: timezone,
        );
        return User(
          cell: e['cell'],
          email: e['email'],
          gender: e['gender'],
          nat: e['nat'],
          phone: e['phone'],
          name: name,
          dob: dob,
          location: location,
        );
      },
    ).toList();
    return users;
  }
}
