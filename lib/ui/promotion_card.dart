import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:me_da_promo/models/promotion.dart';

class PromotionCard extends StatelessWidget {

  final int _id;
  final String _title;
  final FirebaseUser _user;
  final String _price;
  final String _link;
  final String _imageLink;
  final String _description;
  final String _dateCreated;
  final String _dateStarted;
  final String _dateRemoved;
  final String _dateModified;
  final String _coupon;
  final double _rating;

  PromotionCard.fromPromotion(Promotion promotion) :
    _id = promotion.id,
    _title = promotion.title,
    _user = promotion.user,
    _price = promotion.price,
    _link = promotion.link,
    _imageLink = promotion.imageLink,
    _description = promotion.description,
    _dateCreated = promotion.dateCreated,
    _dateStarted = promotion.dateStarted,
    _dateRemoved = promotion.dateRemoved,
    _dateModified = promotion.dateModified,
    _coupon = promotion.coupon,
    _rating = promotion.rating;
    


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
                          backgroundImage: NetworkImage(imageLink),
                          radius: 29.0,
                        )
                      ),
                      title: Text(title,
                        style: TextStyle(
                            color: Colors.white, 
                            fontWeight: FontWeight.bold),
                      ),
                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                      subtitle: Row(
                        children: <Widget>[
                          Icon(Icons.attach_money, color: Colors.white,),
                          Text(price,
                              style: TextStyle(color: Colors.white))
                        ],
                      ),
                      trailing: Icon(Icons.keyboard_arrow_right,
                          color: Colors.white, size: 30.0)
                    )
                  ),                          
            );
  }

  String get description => _description;

  double get rating => _rating;

  String get coupon => _coupon;

  String get dateModified => _dateModified;

  String get dateRemoved => _dateRemoved;

  String get dateStarted => _dateStarted;

  String get dateCreated => _dateCreated;

  String get imageLink => _imageLink;

  String get link => _link;

  String get price => _price;

  FirebaseUser get user => _user;

  String get title => _title;

  int get id => _id;
  
  }