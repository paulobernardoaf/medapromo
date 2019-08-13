import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_da_promo/models/promotion.dart';

class PromotionPage extends StatefulWidget {
  final FirebaseUser user;
  final Promotion promotion;
  PromotionPage({Key key, @required this.user, this.promotion})
      : super(key: key);

  @override
  _PromotionPageState createState() =>
      new _PromotionPageState(user: user, promotion: promotion);
}

class _PromotionPageState extends State<PromotionPage> {
  final FirebaseUser user;
  final Promotion promotion;
  _PromotionPageState({Key key, @required this.user, this.promotion});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ))),
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
                        Divider(),
                        Text(
                          "R\$ ${promotion.price}",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                        Divider(),
                        Text(
                          "R\$ ${promotion.discountCode}",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber),
                        ),
                      ])),
            ),
          ],
        ));
  }
}
