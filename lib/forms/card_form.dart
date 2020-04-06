import 'dart:io';

import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/input_formatters.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:codedecoders/widgets/payment_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardForm extends StatefulWidget {
  final MainModel model;

  const CardForm({Key key, this.model}) : super(key: key);

  @override
  _CardFormState createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  String _appBarText = "Etape 3";
  bool _loading = false;
  var _formKey = new GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var numberController = new TextEditingController();
  var _paymentCard = PaymentCard();
  var _autoValidate = false;

  var _card = new PaymentCard();

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            _bodyContent(context),
            LoadingSpinner(
              loading: _loading,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 2,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            _validateInputs();
          },
        ),
      ),
    );
  }

  Widget _bodyContent(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: HexColor.fromHex("#062b66"),
          expandedHeight: HEADER_HEIGHT,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(_appBarText),
            background: Image.asset(FORM_BACKGROUND_ASSET, fit: BoxFit.cover),
          ),
        ),
        SliverList(
//          itemExtent: 100.0,
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Données de la carte bancaire",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black)),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      tooltip: "Revenir à la page d'accueil",
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/home");
                      },
                    )
                  ],
                ),
              ),
              Divider(
                height: 2,
              ),
              SizedBox(
                height: 20,
              ),
              _formView(),
              SizedBox(
                height: 30,
              ),
              Container(color: Colors.grey.withOpacity(0.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _formView() {
    return new Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: new Form(
          key: _formKey,
          autovalidate: _autoValidate,
          child: new ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              new SizedBox(
                height: 20.0,
              ),
              new TextFormField(
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  icon: const Icon(
                    Icons.person,
                    size: 40.0,
                  ),
                  hintText: 'What name is written on card?',
                  labelText: 'Card Name',
                ),
                onSaved: (String value) {
                  _card.name = value;
                },
                keyboardType: TextInputType.text,
                validator: (String value) => value.isEmpty ? fieldReq : null,
              ),
              new SizedBox(
                height: 30.0,
              ),
              new TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(19),
                  new CardNumberInputFormatter()
                ],
                controller: numberController,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  icon: CardUtils.getCardIcon(_paymentCard.type),
                  hintText: 'What number is written on card?',
                  labelText: 'Number',
                ),
                onSaved: (String value) {
                  print('onSaved = $value');
                  print('Num controller has = ${numberController.text}');
                  _paymentCard.number = CardUtils.getCleanedNumber(value);
                },
                validator: CardUtils.validateCardNum,
              ),
              new SizedBox(
                height: 30.0,
              ),
              new TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(4),
                ],
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  icon: new Image.asset(
                    'assets/card_cvv.png',
                    width: 40.0,
                    color: Colors.grey[600],
                  ),
                  hintText: 'Number behind the card',
                  labelText: 'CVV',
                ),
                validator: CardUtils.validateCVV,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _paymentCard.cvv = int.parse(value);
                },
              ),
              new SizedBox(
                height: 30.0,
              ),
              new TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  new LengthLimitingTextInputFormatter(4),
                  new CardMonthInputFormatter()
                ],
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  icon: new Image.asset(
                    'assets/calender.png',
                    width: 40.0,
                    color: Colors.grey[600],
                  ),
                  hintText: 'MM/YY',
                  labelText: 'Expiry Date',
                ),
                validator: CardUtils.validateDate,
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  List<int> expiryDate = CardUtils.getExpiryDate(value);
                  _paymentCard.month = expiryDate[0];
                  _paymentCard.year = expiryDate[1];
                },
              ),
              new SizedBox(
                height: 50.0,
              ),
              /*new Container(
                alignment: Alignment.center,
                child: _getPayButton(),
              )*/
            ],
          )),
    );
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      print('card type is $cardType');
      this._paymentCard.type = cardType;
    });
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    var msg;
    if (!form.validate()) {
      setState(() {
        _autoValidate = true; // Start validating on every change.
      });
      msg = 'Please fix the errors in red before submitting.';
      showSnackBar(context, msg, status: false, duration: 5);
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      msg = 'La carte de paiement est valide';
      showSnackBar(context, msg, status: false, duration: 5);

//      print('card values is $_card');
//      print('payment values is $_paymentCard');
      widget.model.card = _card;
      widget.model.paymentCard = _paymentCard;
      Navigator.pushNamed(context, "/amount-form/4");
    }
  }
}
