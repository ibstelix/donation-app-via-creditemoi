import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/input_formatters.dart';
import 'package:codedecoders/widgets/item_to_buy_card.dart';
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
  var _phoneController = new TextEditingController();

  List<DropdownMenuItem<String>> _operatorsdropDownMenuItems;
  List<DropdownMenuItem<String>> _groupdropDownMenuItems;
  String _currentOperator;
  String _currentGroup;
  Map _selectedOperator;

  List _listServiceProviders = [];
  List _selectedServiceProviders = [];

  List _listCountries = [];

  List _selectedProviderItems = [];
  Map _selectedItem;

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
            Form(key: _formKey, child: _bodyContent(context)),
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
            if (_selectedOperator == null) {
              showSnackBar(context, "Veuillez d'abord choisir un operateur");
              return;
            }

            if (_phoneController.text.isEmpty) {
              showSnackBar(
                  context, "Veuillez d'abord saisir un numero de telephone",
                  duration: 5);
              return;
            }

            print(isNumeric(_amountController.text));
            if (!isNumeric(_amountController.text)) {
              showSnackBar(context, "Veuillez d'abord saisir un montant valide",
                  duration: 5);
              return;
            }
            widget.model.amount = int.tryParse(_amountController.text);
            widget.model.phone_number = _phoneController.text;
            widget.model.selectedOperator = _selectedOperator;

            Navigator.pushNamed(context, "/confirmation-form/Mobile");

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
              SizedBox(
                height: 30,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: _operatorsDropDown(),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _phoneInput(),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                margin: EdgeInsets.only(right: 20),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _amountInput(),
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

  Widget _amountInput() {
    return TextFormField(
      controller: _amountController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Champ obligatoire';
        }
        return null;
      },
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
    );
  }

  Widget _phoneInput() {
    return TextFormField(
      controller: _phoneController,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Champ obligatoire';
        }

        RegExp regex = new RegExp("[^0][0-9]{8,}");
        if (!regex.hasMatch(value)) {
          return "Le format n'est pas respecté. Minimum 9 chiffres";
        }
        return null;
      },
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly,
      ],
      decoration: new InputDecoration(
        border: InputBorder.none,
        filled: true,
        icon: Icon(Icons.phone),
        hintText: 'Votre Numero de telephone',
        labelText: 'Telephone',
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _operatorsDropDown() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButtonHideUnderline(
              child: SizedBox(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: new DropdownButton(
                    isExpanded: true,
//                              style: Theme.of(context).textTheme.title,
                    hint: new Text("Operateur"),
                    value: _currentOperator,
                    items: _operatorsdropDownMenuItems,
                    onChanged: _operatorChangedDropDownItem,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridViewCards() {
    var selectedIndex = 0;
    print('1. selected index is $selectedIndex');

    return GridView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: _selectedProviderItems.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, i) {
          Map<String, dynamic> servItem = _selectedProviderItems[i];
          return InkWell(
            onTap: () {
              setState(() {
                if (_selectedItem == servItem) {
                  _selectedItem = null;
                } else {
                  _selectedItem = servItem;
                }
              });
            },
            child: ItemToBuyCard(
                checked: _selectedItem != null &&
                    _selectedItem['id'] == servItem['id'],
                model: widget.model,
                data: _selectedProviderItems[i],
                context: context),
          );
        });
  }

  void _anonymeAuthenticate(BuildContext context) async {
    var connected = widget.model.aconnected;
    print('checking connected....$connected');

    setState(() {
      _loading = true;
    });

    if (connected) {
      _processData();
    } else {
      _reconnectAnonymous();
    }
  }

  void _reconnectAnonymous() async {
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
      widget.model.aServiceProviders = _selectedServiceProviders;

      setState(() {
        print('selected providers $_selectedServiceProviders');
        _operatorsdropDownMenuItems =
            _getOperatorsDropDownMenuItems(_selectedServiceProviders);
        _groupdropDownMenuItems =
            _getGroupeYpeDropDownMenuItems(_selectedServiceProviders);
      });
    } else {
      showSnackBar(context, "Aucun operateur supporté pour votre pays",
          status: false, duration: 5);
    }
  }

  List<DropdownMenuItem<String>> _getOperatorsDropDownMenuItems(
      List<dynamic> data) {
    List<DropdownMenuItem<String>> items = new List();

    /* items.add(new DropdownMenuItem(
        value: 'all',
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text("-- Tous --", overflow: TextOverflow.ellipsis),
        )));*/

    for (var val in data) {
//      print('dropdown item $val');

      var leadingIc = Image.network(
        val['logo'],
        width: 30,
      );

      items.add(new DropdownMenuItem(
          value: val['name'],
          child: Row(
            children: <Widget>[
              leadingIc,
              SizedBox(
                width: 10,
              ),
              new Text(val['name'], overflow: TextOverflow.ellipsis),
            ],
          )));
    }
    return items;
  }

  List<DropdownMenuItem<String>> _getGroupeYpeDropDownMenuItems(
      List<dynamic> data) {
    List<DropdownMenuItem<String>> items = new List();

    for (var val in data) {
      items.add(new DropdownMenuItem(
          value: val['name'],
          child: Text(val['name'], overflow: TextOverflow.ellipsis)));
    }
    return items;
  }

  void _operatorChangedDropDownItem(String selected) {
    print("Selected operator  $selected");
    setState(() {
      _selectedProviderItems = [];
      _selectedItem = null;
    });
    _selectedOperator = _selectedServiceProviders
        .firstWhere((i) => i['name'] == selected, orElse: () => null);

    print('selected providers $_selectedOperator');

    setState(() {
      if (_selectedOperator != null) {
        _selectedProviderItems = _selectedOperator['items']
            .where((i) => i['is_withdrawable'] == 0)
            .toList();
      } else {
        if (selected == 'all') {
          _selectedServiceProviders.forEach((mp) => _selectedProviderItems +=
              mp['items'].where((i) => i['is_withdrawable'] == 0).toList());
        }
      }
      _currentOperator = selected;
    });
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
