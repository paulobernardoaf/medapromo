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
        ),
        body: Column(children: <Widget>[
          Container(
              height: 350.0,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _promotions.length,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, position) {
                  return GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        margin: EdgeInsets.all(32.0),
                        child: Container(
                          width: 250.0,
                          height: 300.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        "${_promotions[position].price} reais",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        "${_promotions[position].title}",
                                        style: TextStyle(fontSize: 28.0),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.all(8.0),
                                    //   child: LinearProgressIndicator(value: cardsList[position].taskCompletion,),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                    ),
                    onHorizontalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dx > 0) {
                        if (promotionIndex > 0) promotionIndex--;
                      } else {
                        if (promotionIndex < 2) promotionIndex++;
                      }
                      setState(() {
                        scrollController.animateTo((promotionIndex) * 256.0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      });
                    },
                  );
                },
              )),
        ]));
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
