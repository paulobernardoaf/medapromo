class User {

  final String _nome;
  final String _uid;

  User.fromJSON(Map<String, dynamic> jsonMap):
    _nome = jsonMap['nome'],
    _uid = jsonMap['uid'];

  String get nome => _nome;
  String get uid => _uid;


}