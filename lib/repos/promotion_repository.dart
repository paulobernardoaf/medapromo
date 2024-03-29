import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:me_da_promo/utils/categories_utils.dart';
import 'dart:convert';
import '../models/promotion.dart';
import 'package:dio/dio.dart';

Future<Stream<Promotion>> getPromotions(String filtro) async {
  print(filtro);
  final String url = "https://medapromo.herokuapp.com/promotion" + filtro;

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .expand((data) => (data as List))
      .map((data) => Promotion.fromJSON(data));
}

Future<void> postPromotion(
    FirebaseUser user,
    String promotionLink,
    String title,
    String price,
    String description,
    String imageLink,
    String discountCode,
    Categories categories,
    DateTime dateEnd) async {
  final String url = 'https://medapromo.herokuapp.com/promotion';

  Map<String, dynamic> body = {
    'titulo': title,
    'link': promotionLink,
    'usuario': user.uid,
    'preco': price,
    'imagem': imageLink,
    'descricao': description,
    'codigo_desconto': discountCode,
    'data_termino': dateEnd
  };

  dynamic response = await Dio().post(url,
      data: body,
      options: new Options(
          contentType: ContentType.parse("application/x-www-form-urlencoded")));
  await categories.postForCategories(response.data['insertId']);

  print("post feito");
}
