import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:me_da_promo/models/promotion.dart';
import 'package:me_da_promo/repos/promotion_repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../auth.dart';
import 'custom_card.dart';

class HomePage extends StatefulWidget {
  final FirebaseUser user;
  HomePage({Key key, @required this.user}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState(user: user);
}

class _HomePageState extends State<HomePage> {
  final FirebaseUser user;
  int promotionIndex = 0;
  List<Promotion> _promotions = <Promotion>[];
  _HomePageState({Key key, @required this.user});

  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    listenForPromotions();
    scrollController = new ScrollController();
  }

  void listenForPromotions() async {
    final Stream<Promotion> stream = await getPromotions(user);
    stream.listen(
        (Promotion promotion) => setState(() => _promotions.add(promotion)));
  }

  Choice _selectedChoice = choices[0];
  void _select(Choice choice) {
    // Causes the app to rebuild with the new _selectedChoice.
    setState(() {
      _selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(user.photoUrl),
                backgroundColor: Colors.transparent,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                authService.signOut();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ), // Populate the Drawer in the next step.
      ),
      appBar: new AppBar(
        title: Text("HomePage"),
        backgroundColor: Colors.grey,
      ),
      body: Container(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _promotions.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 8.0,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              color: Colors.transparent,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: new BorderRadius.circular(8.0),
                    color: Colors.grey,
                    ),                  
                  child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      leading: Container(
                        padding: EdgeInsets.only(right: 12.0),
                        decoration: new BoxDecoration(
                            border: new Border(
                                right: new BorderSide(width: 1.0, color: Colors.white24))),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(_promotions[index].imageLink),
                          radius: 29.0,
                        )
                      ),
                      title: Text(_promotions[index].title,
                        style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.attach_money, color: Colors.white,),
                          Text(_promotions[index].price,
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Colors.white, size: 30.0)
                    )
                  ),                          
            );
          },
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'SignOut', icon: MdiIcons.exitToApp),
];
