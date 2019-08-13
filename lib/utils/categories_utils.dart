import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:me_da_promo/utils/categories_enum.dart';

class Categories {
  bool automotivos = false;
  bool compEInfor = false;
  bool celESmart = false;
  bool livros = false;
  bool eletrodom = false;
  bool tvsomvideo = false;
  bool outros = false;

  Future<void> postForCategories(int promotionId) async {
    print(promotionId);
    String postUrl = "";

    String url = 'https://medapromo.herokuapp.com/promotion/$promotionId/';

    if (automotivos == true) {
      postUrl = url + "2";
      Dio().post(postUrl);
    }
    if (compEInfor == true) {
      postUrl = url + "3";
      Dio().post(postUrl);
    }
    if (celESmart == true) {
      postUrl = url + "4";
      Dio().post(postUrl);
    }
    if (livros == true) {
      postUrl = url + "5";
      Dio().post(postUrl);
    }
    if (eletrodom == true) {
      postUrl = url + "6";
      Dio().post(postUrl);
    }
    if (tvsomvideo == true) {
      postUrl = url + "7";
      Dio().post(postUrl);
    }
    if (outros == true) {
      postUrl = url + "8";
      Dio().post(postUrl);
    }
  }
}
