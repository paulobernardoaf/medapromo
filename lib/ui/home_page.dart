import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_da_promo/models/promotion.dart';
import 'package:me_da_promo/repos/promotion_repository.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:me_da_promo/ui/promotion_card.dart';
import 'package:me_da_promo/ui/promotion_create.dart';
import 'package:me_da_promo/ui/promotion_page.dart';
import 'package:me_da_promo/utils/categories_enum.dart';
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
  int bottomBarIndex = 1;
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Promoções');
  final TextEditingController _search = new TextEditingController();

  @override
  void initState() {
    super.initState();
    listenForPromotions();
    scrollController = new ScrollController();
  }

  void listenForPromotions() async {
    Stream<Promotion> stream = await getPromotions("");
    stream.listen(
        (Promotion promotion) => setState(() => _promotions.add(promotion)));
    isLoading = false;
  }

  Future<Null> _refresh(int index) async {
    String param = "";

    if (index == 0) {
      param = "?param=preco&order=asc";
    } else if (index == 2) {
      param = "?param=data_cadastro&order=desc";
    }

    setState(() {
      isLoading = true;
    });

    _promotions = <Promotion>[];
    final Stream<Promotion> stream = await getPromotions(param);
    stream.listen(
        (Promotion promotion) => setState(() => _promotions.add(promotion)));
    isLoading = false;
    return null;
  }

  Future<Null> _refreshForCategories(int index) async {
    String param = "/bycategory/$index";

    setState(() {
      isLoading = true;
    });
    _promotions = <Promotion>[];
    final Stream<Promotion> stream = await getPromotions(param);
    stream.listen(
        (Promotion promotion) => setState(() => _promotions.add(promotion)));
    isLoading = false;
    return null;
  }

  Future<Null> _refreshSearch(String search) async {
    String param = "?search=" + search;

    setState(() {
      isLoading = true;
    });
    _promotions = <Promotion>[];
    final Stream<Promotion> stream = await getPromotions(param);
    stream.listen(
        (Promotion promotion) => setState(() => _promotions.add(promotion)));
    isLoading = false;
    return null;
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _search,
          maxLines: 1,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search, color: Colors.white),
              hintText: 'Busca...',
              hintStyle: TextStyle(color: Colors.white54, fontSize: 16)),
          onSubmitted: (v) => _refreshSearch(v),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Promoções');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                user.displayName,
                style: TextStyle(fontSize: 16),
              ),
              accountEmail: Text(user.email, style: TextStyle(fontSize: 16)),
              currentAccountPicture: CircularProfileAvatar(
                user.photoUrl != null ? user.photoUrl : "",
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
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                "Categorias",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Divider(
              color: Colors.grey,
              endIndent: 8,
              indent: 8,
            ),
            drawerCategorie(categoriesEnum.automotivos.index, "Automotivos",
                FontAwesomeIcons.carAlt),
            drawerCategorie(categoriesEnum.compEInfor.index,
                "Computadores e Informática", FontAwesomeIcons.laptop),
            drawerCategorie(categoriesEnum.celESmart.index,
                "Celulares e Smartphones", FontAwesomeIcons.mobileAlt),
            drawerCategorie(
                categoriesEnum.livros.index, "Livros", FontAwesomeIcons.book),
            drawerCategorie(categoriesEnum.eletrodom.index, "Eletrodomésticos",
                FontAwesomeIcons.plug),
            drawerCategorie(categoriesEnum.tvsomvideo.index, "Tv, Som e Vídeo",
                FontAwesomeIcons.tv),
            drawerCategorie(categoriesEnum.outros.index, "Outros",
                FontAwesomeIcons.thLarge),
            Divider(
              color: Colors.grey,
              endIndent: 8,
              indent: 8,
            ),
            ListTile(
              title: Text('Sair', style: TextStyle(fontSize: 20)),
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
        title: _appBarTitle,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 16),
              child: IconButton(
                  onPressed: () => _searchPressed(), icon: _searchIcon))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PromotionPage(
                                    user: user,
                                    promotion: _promotions[index])));
                      },
                      child: PromotionCard.fromPromotion(_promotions[index]));
                },
              ),
            )),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PromotionCreate(user: user)))
                .then((value) => _refresh(bottomBarIndex));
          }),
      bottomNavigationBar: new BottomNavigationBar(
        currentIndex: bottomBarIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.redAccent,
        items: [
          BottomNavigationBarItem(
              title: Text(
                "Menor preço",
              ),
              icon: Icon(FontAwesomeIcons.fire)),
          BottomNavigationBarItem(
              title: Text(
                "Home",
              ),
              icon: Icon(FontAwesomeIcons.home)),
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

  Widget drawerCategorie(categorieIndex, String title, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.redAccent,
      ),
      title: Text(title, style: TextStyle(fontSize: 18)),
      onTap: () {
        _refreshForCategories(
            categorieIndex + 2); //IN DATABASE THE CATEGORIES ID STARTS AT 2
        Navigator.pop(context);
      },
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
