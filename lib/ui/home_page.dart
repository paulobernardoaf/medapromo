import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_da_promo/models/promotion.dart';
import 'package:me_da_promo/repos/promotion_repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_da_promo/ui/promotion_card.dart';
import 'package:me_da_promo/ui/promotion_create.dart';
import 'package:me_da_promo/ui/promotion_page.dart';
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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = new GlobalKey<RefreshIndicatorState>();
  int bottomBarIndex = 0;

  @override
  void initState() {
    super.initState();
    listenForPromotions();
    scrollController = new ScrollController();
  }

  void listenForPromotions() async {
    Stream<Promotion> stream = await getPromotions(user, "");
    stream.listen(
        (Promotion promotion) => setState(() => _promotions.add(promotion)));
        isLoading = false;
  }

  Future<Null> _refresh(int index) async {
    String param = "";

    if(index == 1) {
      param = "?param=data_cadastro&order=desc";
    }

    setState(() {
     isLoading = true; 
    });
    _promotions = <Promotion>[];    
    final Stream<Promotion> stream = await getPromotions(user, param);
    stream.listen((Promotion promotion) => setState(() => _promotions.add(promotion)));
    isLoading = false;
    return null;
  }

  @override
  Widget build(BuildContext context) {

    FocusScope.of(context).unfocus();

    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
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
                  user.displayName.substring(0, 1),
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
                elevation: 5.0,
                cacheImage: true,
              ),
              decoration: BoxDecoration(
                color: Colors.redAccent,
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
        title: Text("Promoções"),
        backgroundColor: Colors.redAccent,
      ),
      body: isLoading ? 
        Center(child: CircularProgressIndicator(),) 
        : 
        Container(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () => _refresh(bottomBarIndex),
          child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: _promotions.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PromotionPage(user: user, promotion: _promotions[index])
                ));
              },
              child: PromotionCard.fromPromotion(_promotions[index])
            ); 
          },
        ),)          
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
                  builder: (context) => PromotionCreate(user: user)
          )).then((value) => _refresh(bottomBarIndex));
        }
      ),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: bottomBarIndex,        
        selectedItemColor: Colors.white,
        backgroundColor: Colors.redAccent,
        items: [
          BottomNavigationBarItem(
            title: Text("Home",),
            icon: Icon(FontAwesomeIcons.home)
          ),
          BottomNavigationBarItem(
            title: Text("Novos"), 
            icon: Icon(Icons.new_releases),
          ),
        ],
        onTap: (index) {
          print(index);
          setState(() {
           bottomBarIndex = index;
           _refresh(index);
          });
        },
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

