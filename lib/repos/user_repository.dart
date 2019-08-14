import 'package:http/http.dart' as http;
import 'package:me_da_promo/models/user.dart';
import 'dart:convert';

Future<Stream<User>> getUser(String uid) async {

  final String url = "https://medapromo.herokuapp.com/user/" + uid;

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .expand((data) => (data as List))
      .map((data) => User.fromJSON(data));
}

