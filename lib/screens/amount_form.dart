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

class AmountForm extends StatefulWidget {
  final MainModel model;
  final int stepIndex;

  const AmountForm({Key key, this.model, this.stepIndex = 0}) : super(key: key);

  @override
  _AmountFormState createState() => _AmountFormState();
}

class _AmountFormState extends State<AmountForm> {
  String _appBarText = "";
  bool _loading = false;
  var _formKey = new GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _amountController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _appBarText = "Etape ${widget.stepIndex}";
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
                    Text("Saisir le Montant",
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
                height: 50,
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
          child: new ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              new TextFormField(
                controller: _amountController,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                ],
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  icon: Icon(Icons.dialpad),
                  hintText: 'Votre donation',
                  labelText: 'Montant',
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 80.0,
              ),
              new Container(
                alignment: Alignment.center,
                child: _getPayButton(),
              )
            ],
          )),
    );
  }

  void _validateInputs() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      // Encrypt and send send payment details to payment gateway
      _showInSnackBar('Payment card is valid');
    }
  }

  Widget _getPayButton() {
    if (Platform.isIOS) {
      return new CupertinoButton(
        onPressed: _validateInputs,
        color: CupertinoColors.activeBlue,
        child: const Text(
          PAY,
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    } else {
      return new RaisedButton(
        onPressed: _validateInputs,
        color: Colors.blue,
        splashColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(const Radius.circular(100.0)),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
        textColor: Colors.white,
        child: new Text(
          PAY.toUpperCase(),
          style: const TextStyle(fontSize: 17.0),
        ),
      );
    }
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }
}
