import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_da_promo/models/promotion.dart';

class PromotionCard extends StatelessWidget {
  final Promotion _promotion;

  PromotionCard.fromPromotion(Promotion promotion) : _promotion = promotion;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      color: Colors.transparent,
      child: Container(
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.circular(8.0),
            color: Colors.white,
          ),
          child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right: new BorderSide(
                              width: 1.0, color: Colors.black38))),
                  child: SizedBox(
                    width: 70,
                    height: 70,
                    child: CachedNetworkImage(
                      imageUrl: imageLink,
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(FontAwesomeIcons.image),
                      fit: BoxFit.scaleDown,
                    ),
                  )),
              title: Text(
                title,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
              subtitle: Row(
                children: <Widget>[
                  Divider(
                    color: Colors.red,
                    height: 16,
                  ),
                  Text(
                    "R\$ ",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(price, style: TextStyle(color: Colors.black))
                ],
              ),
              trailing: Icon(Icons.keyboard_arrow_right,
                  color: Colors.black, size: 30.0))),
    );
  }

  String get description => _promotion.description;

  int get rating => _promotion.rating;

  String get discountCode => _promotion.discountCode;

  String get dateModified => _promotion.dateModified;

  String get dateRemoved => _promotion.dateRemoved;

  String get dateCreated => _promotion.dateCreated;

  String get imageLink => _promotion.imageLink;

  String get link => _promotion.link;

  String get price => _promotion.price;

  String get user => _promotion.user;

  String get title => _promotion.title;

  int get id => _promotion.id;
}
