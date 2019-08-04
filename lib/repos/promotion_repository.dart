import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/promotion.dart';

Future<Stream<Promotion>> getPromotions(FirebaseUser user) async {
  final String url = 'http://192.168.0.14:3000/promotion';

  final client = new http.Client();
  final streamedRest = await client.send(
      http.Request('get', Uri.parse(url))
  );

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .expand((data) => (data as List))
      .map((data) => Promotion.fromJSON(data, user));
}