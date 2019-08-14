import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class Promotion {

  final int _id;
  final String _title;
  final FirebaseUser _user;
  final String _price;
  final String _link;
  final String _imageLink;
  final String _description;
  final String _dateCreated;
  final String _dateRemoved;
  final String _dateModified;
  final String _discountCode;
  final int _rating;

  Promotion.fromJSON(Map<String, dynamic> jsonMap, FirebaseUser user) :

    _id = jsonMap['id'],
    _title = jsonMap['titulo'],
    _user = user,
    _price = jsonMap['preco'].toString(), 
    _link = jsonMap['link'],
    _imageLink = jsonMap['imagem'],
    _description = jsonMap['descricao'],
    _dateCreated = new DateFormat("dd-MM-yyyy H:mm:ss").format(DateTime.parse(jsonMap['data_cadastro'])),
    _dateRemoved = jsonMap['data_remocao'] != null ? new DateFormat("dd-MM-yyyy H:mm:ss").format(DateTime.parse(jsonMap['data_remocao'])) : null,
    _dateModified = jsonMap['data_modificacao'] != null ? new DateFormat("dd-MM-yyyy H:mm:ss").format(DateTime.parse(jsonMap['data_modificacao'])) : null,
    _discountCode = jsonMap['codigo_desconto'],
    _rating = jsonMap['avaliacao'];


  String get description => _description;

  int get rating => _rating;

  String get discountCode => _discountCode;

  String get dateModified => _dateModified;

  String get dateRemoved => _dateRemoved;

  String get dateCreated => _dateCreated;

  String get imageLink => _imageLink;

  String get link => _link;

  String get price => _price;

  FirebaseUser get user => _user;

  String get title => _title;

  int get id => _id;


}