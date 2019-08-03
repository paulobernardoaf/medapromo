import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';

class HomePage extends StatefulWidget {

  
  final FirebaseUser user;

  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState(user: user);


}

class _HomePageState extends State<HomePage> {  

  final FirebaseUser user;

  _HomePageState({Key key, @required this.user});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("HomePage"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(user.email),
            MaterialButton(
              onPressed: () {
                authService.signOut().then((value) => Navigator.pop(context));
              }, 
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Signout'),
            ),
          ],
        )
      )
    );
  }


}
