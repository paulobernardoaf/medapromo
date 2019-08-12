import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/promotion.dart';
import 'package:dio/dio.dart';

Future<Stream<Promotion>> getPromotions(FirebaseUser user) async {
  final String url = 'https://medapromo.herokuapp.com/promotion';

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

Future<void> postPromotion(FirebaseUser user, String promotionLink, String title, String price, String description, String imageLink, String discountCode) async {

  final String url = 'https://medapromo.herokuapp.com/promotion';

  Map<String, String> body = {
    'titulo': title,
    'link' : promotionLink,
    'usuario' : "1",
    'preco' : price,
    'imagem' : imageLink,
    'descricao' : description,
    'codigo_desconto' : discountCode
  };

  await Dio().post(url,data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))); 

  print("post feito");

}