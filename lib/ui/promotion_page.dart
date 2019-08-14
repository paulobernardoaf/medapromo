import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_da_promo/models/promotion.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:me_da_promo/models/user.dart';
import 'package:me_da_promo/repos/user_repository.dart';
import 'package:url_launcher/url_launcher.dart'; 

class PromotionPage extends StatefulWidget {
  final FirebaseUser user;
  final Promotion promotion;
  PromotionPage({Key key, @required this.user, this.promotion}) : super(key: key);

  @override
  _PromotionPageState createState() => new _PromotionPageState(user: user, promotion: promotion);
}

class _PromotionPageState extends State<PromotionPage> {
  final FirebaseUser user;
  String _promotionUser = "";
  final Promotion promotion;
  _PromotionPageState({Key key, @required this.user, this.promotion});

  @override
  void initState() {
    getUserName();
  }

  void getUserName() async {
    
   Stream<User> users = await getUser(promotion.user);

   users.listen((User user) => setState(() => _promotionUser = user.nome));

  }

  final key = new GlobalKey<ScaffoldState>();

  _launchURL() async {
  String url = promotion.link;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        key: key,
        appBar: new AppBar(
          backgroundColor: Colors.redAccent,
          centerTitle: true,
          title: Text("Promoção"),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(right: 12, left: 12, bottom: 12),
          children: <Widget>[
            GestureDetector(
                onTap: () => print("CLICOU NA IMAGEM"),
                child: Material(
                    elevation: 2,
                    child: CachedNetworkImage(
                      imageUrl: promotion.imageLink,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) => new Image.asset(
                        "assets/image-not-found.jpg",
                        fit: BoxFit.contain,
                      ),
                      fit: BoxFit.fitWidth,
                      height: 300,
                      width: ScreenUtil.instance.width,
                      alignment: Alignment.center,
                    )
                )
            ),
            Material(
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        promotion.title,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20,),
                      Text("Autor: " + _promotionUser, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                      Divider(),
                      SizedBox(height: 20,),
                      showDiscountCode(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "R\$ ${promotion.price}",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                      Divider(),
                      Center(
                        child: SizedBox(
                          width: double.infinity,
                          child:  RaisedButton(
                            onPressed: () => _launchURL(),
                            child: Text("Ir para o site", style: TextStyle(color: Colors.white, fontSize: 16),),
                            color: Colors.redAccent,
                          )
                        )
                      ),
                      Divider(),
                      Text("Descrição:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),),
                      Card(
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text(promotion.description, style: TextStyle(fontSize: 16),),
                        )
                      )
                    ]
                )
              ),
            ),
          ],
        ));
  }

  Widget showDiscountCode() {
    if(promotion.discountCode.isNotEmpty) {
      return Center(
        child: DottedBorder(
          color: Colors.redAccent,
          strokeWidth: 1,
          padding: EdgeInsets.all(12),
          child: Card(
            elevation: 0,
            child: new GestureDetector(
              onLongPress: () {
                Clipboard.setData(new ClipboardData(text: promotion.discountCode));
                key.currentState.showSnackBar(
                    new SnackBar(content: new Text("Copied to Clipboard"),));
              },
              child: Text(
              promotion.discountCode,
              style: TextStyle(
                color: Colors.redAccent, 
                fontWeight: FontWeight.bold,
                fontSize: 26
              ),
            ),
            )
          )
        )
      );
    } else {
      return SizedBox(height: 0,);
    }

   

  

  }
}
