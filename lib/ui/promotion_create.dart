import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:me_da_promo/repos/promotion_repository.dart';
import 'package:validators/validators.dart';
import 'package:validators/sanitizers.dart';

import 'home_page.dart';

class PromotionCreate extends StatefulWidget {
  final FirebaseUser user;
  PromotionCreate({Key key, @required this.user}) : super(key: key);

  @override
  _PromotionCreateState createState() => new _PromotionCreateState(user: user);

}

class _PromotionCreateState extends State<PromotionCreate> {
  FirebaseUser user;
  final _formKey = new GlobalKey<FormState>();

  Text calendarText = Text("Termina em");
  bool validTime = true;

  _PromotionCreateState({Key key, @required this.user});

  TextEditingController titleController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController imageLinkController = new TextEditingController();
  TextEditingController promotionLinkController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();
  TextEditingController discountCodeController = new TextEditingController();

  String _title = "";
  String _price = "";
  String _imageLink = "";
  String _promotionLink = "";
  String _description = "";
  String _discountCode = "";

  void changeVariable(String variable, String newValue) {

      switch (variable) {
        case "promotionLink":
          _promotionLink = newValue;
          break;
        case "title":
          _title = newValue;
          break;
        case "price":
          _price = newValue;
          break;
        case "description":
          _description = newValue;
          break;
        case "imageLink":
          _imageLink = isURL(newValue, allowUnderscore: true) ? newValue : null;
          break;
        case "discountCode":
          _discountCode = newValue;
          break;
      }

    }

  @override
  Widget build(BuildContext context) {

    DateTime selectedDate = DateTime.now();    


    Future<Null> _selectDate(BuildContext context) async {
      DateFormat format = new DateFormat("dd/MM/yyyy");
      final DateTime picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2015, 8),
          lastDate: DateTime(2101));
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          if(selectedDate.difference(DateTime.now()).inMilliseconds > 0) {
            calendarText = Text(format.format(selectedDate));
            validTime = true;
          } else {
            calendarText = Text("Data inválida");
            validTime = false;
          }
        });
    }

    void _validateForm() async {
      final form = _formKey.currentState;
      if(form.validate()) {
        form.save();
        print("form válido");
        await postPromotion(user, _promotionLink, _title, _price, _description, _imageLink, _discountCode);
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => HomePage(user: user,)
        ));        
      } else {
        print("form inválido");
      }
    }

    

    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Adicione uma promoção"),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.check),
            onPressed: () {
              _validateForm();
              // enviar o form
              // voltar pra pag inicial
            },
          )
        ],
      ),
      body: new Padding(
        padding: EdgeInsets.all(16),
        child: new Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(12),
            children: <Widget>[
              _formField(promotionLinkController, "Link da Promoção", FontAwesomeIcons.link, true, "Link", _promotionLink),
              SizedBox(height: 40,),
              _formField(titleController, "Título da Promoção", FontAwesomeIcons.font, true, "Título", "title"),
              SizedBox(height: 40,),
              _formField(priceController, "Valor do produto", FontAwesomeIcons.moneyBillAlt, true, "Valor", "price"),
              SizedBox(height: 40,),
              _formField(descriptionController, "Descrição da promoção/produto", FontAwesomeIcons.stream, true, "Descrição", "description"),
              SizedBox(height: 40,),
              _formField(imageLinkController, "Link para imagem", FontAwesomeIcons.solidImage, true, "Link da Imagem", "imageLink"),
              SizedBox(height: 40,),
              TextField(
                decoration: InputDecoration(
                  icon: Icon(
                    FontAwesomeIcons.calendar,
                    color: Colors.black,
                    size: 22.0,
                  ),
                  hintText: calendarText.data,
                  hintStyle: TextStyle(
                    fontFamily: "WorkSansSemiBold",
                    fontSize: 17.0,
                    color: (validTime == true) ? null : Colors.red,
                  ),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              SizedBox(height: 40,),
              _formField(discountCodeController, "Código de desconto(Opcional)", FontAwesomeIcons.tag, false, "Código de Desconto", "discountCode"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _formField(TextEditingController controller, String hintText, IconData icon, bool mandatory, String field, String varName) {
    return new TextFormField(
      controller: controller,
      style: TextStyle(
          fontFamily: "WorkSansSemiBold",
          fontSize: 16.0,
          color: Colors.black),
      decoration: InputDecoration(
        icon: Icon(
          icon,
          color: Colors.black,
          size: 22.0,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
            fontFamily: "WorkSansSemiBold", fontSize: 17.0),
      ),
      validator: (value) => value.isEmpty && mandatory ? "${field} não pode ser vazio" : null,
      onSaved: (value) => changeVariable(varName, value),
    );
  }
  

}