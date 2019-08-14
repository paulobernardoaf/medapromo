import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:me_da_promo/models/promotion.dart';
import 'package:http/http.dart' as http;

class PromotionCard extends StatefulWidget {
  final Promotion promotion;
  final FirebaseUser actualUser;

  PromotionCard({Key key, @required this.promotion, this.actualUser}) : super(key:key);

  @override
  _PromotionCardState createState() => _PromotionCardState(promotion: promotion, actualUser: actualUser);
}

class _PromotionCardState extends State<PromotionCard> {
  final FirebaseUser actualUser;
  final Promotion promotion;

  _PromotionCardState({Key key, @required this.promotion, this.actualUser});

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
                  )
              ),
              title: Text(
                title,
                maxLines: 2,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                children: <Widget>[
                  Divider(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Text(
                              "R\$ ",
                              style: TextStyle(
                                  color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                            Text(price, style: TextStyle(color: Colors.black)),
                          ],
                      ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => ratingMinus(actualUser.uid),
                            child: Icon(
                              FontAwesomeIcons.minus,
                              size: 17.0,
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          getEmojis(),
                          SizedBox(
                            width: 10.0,
                          ),
                          GestureDetector(
                            onTap: () => ratingPlus(actualUser.uid),
                            child: Icon(
                              FontAwesomeIcons.plus,
                              size: 17.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                  ),
                ],
              ), 
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black, size: 30.0
                  )
                ]
              ),
            )
          ),
    );
  }

  Widget getEmojis(){
    if(promotion.rating < -5) {
      return Icon(FontAwesomeIcons.angry, size: 17.0);
    }
    else if(promotion.rating < 0) {
      return Icon(FontAwesomeIcons.frown, size: 17.0);
    }
    else if(promotion.rating == 0) {
      return Icon(FontAwesomeIcons.meh, size: 17.0);
    }
    else if(promotion.rating < 5) {
      return Icon(FontAwesomeIcons.smileBeam, size: 17.0);
    }
    else {
      return Icon(FontAwesomeIcons.laughBeam, size: 17.0);
    }
  }

  Future<void> ratingMinus(String user) async {
    print("minus");
    final String url = "https://medapromo.herokuapp.com/promotion/vote/" + promotion.id.toString() + "/" + user + "?menos=a";

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  }

  Future<void> ratingPlus(String user) async {
    print("plus");
    final String url = "https://medapromo.herokuapp.com/promotion/vote/" + promotion.id.toString() + "/" + user + "?mais=a";

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  }

  String get description => promotion.description;

  int get rating => promotion.rating;

  String get discountCode => promotion.discountCode;

  String get dateModified => promotion.dateModified;

  String get dateRemoved => promotion.dateRemoved;

  String get user => promotion.user;

  String get dateCreated => promotion.dateCreated;

  String get imageLink => promotion.imageLink;

  String get link => promotion.link;

  String get price => promotion.price;

  String get title => promotion.title;

  int get id => promotion.id;
}