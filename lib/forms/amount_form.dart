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
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 2,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (!_formKey.currentState.validate()) {
              return;
            }

            if (!isNumeric(_amountController.text)) {
              showSnackBar(context, "Veuillez d'abord saisir un montant valide",
                  duration: 5);
              return;
            }
            widget.model.amount = int.tryParse(_amountController.text);

            Navigator.pushNamed(context, "/confirmation-form/Bank");

            /* widget.model.selected_country_code = _currentCountry;
            var selected_op_type = _operatorsTypes[_selected_operator_index];
            widget.model.selected_operator_type = selected_op_type;
            Navigator.pushNamed(context, "/$selected_op_type");*/
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
              /* new Container(
                alignment: Alignment.center,
                child: _getPayButton(),
              )*/
            ],
          )),
    );
  }

  void _showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      duration: new Duration(seconds: 3),
    ));
  }
}
