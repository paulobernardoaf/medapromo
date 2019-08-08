import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:me_da_promo/models/promotion.dart';
import 'package:me_da_promo/repos/promotion_repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_da_promo/ui/promotion_card.dart';
import '../auth.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';

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
  bool isLoading = true;
  ScrollController scrollController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

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
        isLoading = false;
  }

  Future<Null> _refresh() async {
    _promotions = <Promotion>[];
    final Stream<Promotion> stream = await getPromotions(user);
    stream.listen(
        (Promotion promotion) => setState(() => _promotions.add(promotion)));
        isLoading = false;
    return null;
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

    FocusScope.of(context).unfocus();

    return Scaffold(
      drawer: Drawer(
        child: 
        ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName),
              accountEmail: Text(user.email),
              currentAccountPicture: CircularProfileAvatar(user.photoUrl != null ? user.photoUrl : "",
                radius: 100, 
                backgroundColor: Colors.indigoAccent,
                initialsText: Text(
                  user.displayName.substring(0, 2),
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                elevation: 5.0,
                cacheImage: true,
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
      body: isLoading ? 
        Center(child: CircularProgressIndicator(),) 
        : 
        Container(
        child: RefreshIndicator(
    key: _refreshIndicatorKey,
    onRefresh: _refresh,
    child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _promotions.length,
          itemBuilder: (BuildContext context, int index) {
            return PromotionCard.fromPromotion(_promotions[index]);
          },
        ),)          
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

