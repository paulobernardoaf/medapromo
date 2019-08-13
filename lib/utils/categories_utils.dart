class Categories {

  bool automotivos = false;
  bool compEInfor = false;
  bool celESmart = false;
  bool livros = false;
  bool eletrodom = false;
  bool tvsomvideo = false;
  bool outros = false;  

  Future<void> postForCategories() async {

      final String url = 'https://medapromo.herokuapp.com/promotion';

    if(automotivos == true) {
      // Dio().post(url,data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded"))); 
    }

  }

}