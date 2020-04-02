import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/input_formatters.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:codedecoders/widgets/payment_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OperatorForm extends StatefulWidget {
  final MainModel model;

  const OperatorForm({Key key, this.model}) : super(key: key);

  @override
  _OperatorFormState createState() => _OperatorFormState();
}

class _OperatorFormState extends State<OperatorForm>
    with AfterLayoutMixin<OperatorForm> {
  String _appBarText = "Etape 2";
  bool _loading = false;
  var _formKey = new GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _amountController = new TextEditingController();

  List<DropdownMenuItem<String>> _operatorsdropDownMenuItems;
  List<DropdownMenuItem<String>> _groupdropDownMenuItems;
  String _currentOperator;
  String _currentGroup;
  Map _selectedOperator;
  List _listServiceProviders = [];
  List _selectedServiceProviders;

  List _listCountries = [];

  @override
  void afterFirstLayout(BuildContext context) {
    _anonymeAuthenticate(context);
  }

  @override
  void initState() {
    super.initState();
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
          expandedHeight: 130.0,
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
              /*Padding(
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
              ),*/
              Divider(
                height: 2,
              ),
              SizedBox(
                height: 20,
              ),
              Container(color: Colors.grey.withOpacity(0.3)),
            ],
          ),
        ),
      ],
    );
  }

  void _anonymeAuthenticate(BuildContext context) async {
    var connected = widget.model.aconnected;
    print('checking connected....$connected');

    if (connected) {
      _processData();
    } else {
      _reconnectAnonymous();
    }
  }

  void _reconnectAnonymous() async {
    setState(() {
      _loading = true;
    });
    Map<String, dynamic> sendData = {
      'pseudo': default_anon_user,
      'password': 'rdcdev!!?',
    };
    String url = '${baseurl}public/auth';
    var auth_res = await widget.model.post_api(sendData, url);
    print('auth_res is $auth_res');
    checkErrorMessge(auth_res);

    if (auth_res['status']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      widget.model.aconnected = true;
      prefs.setBool(CONNECTED_KEY, true);
      prefs.setString(TOKEN, auth_res['msg']['token']);

      var user_url = '${baseurl}auth/me';
      var user_res = await widget.model.get_api(user_url, true);
      print('user_res is $user_res');
      checkErrorMessge(user_res);
      if (user_res['status']) {
        widget.model.anonymous_user = user_res['msg'];
        //success
        _processData();
      }
    }
  }

  void _processData() async {
    if (widget.model.aServiceProviders.length == 0) {
      var url = '${baseurl}auth/service_providers';
      print('get API Data service_providers');
      var res = await widget.model.get_api(url, true);
      checkErrorMessge(res);

      if (res['status']) {
        setState(() {
          _loading = false;
        });

        List data = res['msg'];
        if (data.length == 0) {
          showSnackBar(context, "Aucun operateur trouvé",
              status: false, duration: 5);
        } else {
          widget.model.aServiceProviders = data;
          _processServicePRovidersData(data);
        }
      }
    } else {
      setState(() {
        _loading = false;
      });
      _processServicePRovidersData(widget.model.aServiceProviders);
    }
  }

  void _processServicePRovidersData(data) {
    _listServiceProviders = data;
    var listCountries = [];
    for (var val in data) {
      var country = val['country'];
      listCountries.add(country);
    }

    _listCountries = Set.of(listCountries).toList();
    print('listcountries is $_listCountries');
    var mapCountryCode = _listCountries.firstWhere(
        (i) => i.toUpperCase() == widget.model.selected_country_code,
        orElse: () => null);
    print(
        'mapcountrycode is ${widget.model.selected_country_code} \n$mapCountryCode');

    if (mapCountryCode != null) {
      _selectedServiceProviders = _listServiceProviders
          .where((i) => i['country'] == mapCountryCode)
          .toList();
      setState(() {
        print('selected providers $_selectedServiceProviders');
      });
    } else {
      showSnackBar(context, "Aucun operateur supporté pour votre pays",
          status: false, duration: 5);
    }
  }

  void _validateInputs() {}

  checkErrorMessge(res) {
    setState(() {
      _loading = false;
    });
    if (!res['status']) {
      var msg = res.containsKey('msg')
          ? res['msg']
          : "Une Erreur s'est produite. Veuillez contacter l'Admin";
//      Navigator.of(_scaffoldKey.currentContext).pop(msg);
    }
  }
}
