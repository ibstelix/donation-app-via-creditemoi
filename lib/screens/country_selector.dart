import 'dart:convert';

import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CountrySelector extends StatefulWidget {
  final MainModel model;

  const CountrySelector({Key key, this.model}) : super(key: key);

  @override
  _CountrySelectorState createState() => _CountrySelectorState();
}

class _CountrySelectorState extends State<CountrySelector> {
  bool _loading = false;

  String _appBarText = "Etape 1";
  Map _default_ip_data;

  List<DropdownMenuItem<String>> _countrydropDownMenuItems;
  String _currentCountry;

  List<DropdownMenuItem<String>> _operatorTypedropDownMenuItems;
  String _currentOperatorType;

  List _MapCountries = [];

  @override
  void initState() {
    super.initState();
    _getUserIpInfo().then((data) {
      _default_ip_data = data;
      _getAllCountries();
    });
  }

  _getAllCountries() async {
    List countries_data = await _get_last_info(COUNTRIES_KEY, "");
    if (countries_data != null) {
      print(countries_data[0]);
      _MapCountries = countries_data;
      print('found saved countries');
      setState(() {
        _countrydropDownMenuItems =
            _getCountryDropDownMenuItems(countries_data);
        _currentCountry =
            _default_ip_data == null ? "" : _default_ip_data['cc'];
      });
      return;
    }

    const url = "http://countryapi.gear.host/v1/Country/getCountries";
    var res = await widget.model.get_api(url);
    print(res.runtimeType);
    print(res);
    if (!res['status']) {
      countries_data = await _get_last_info(COUNTRIES_KEY, "");
    } else {
      countries_data = res['msg']['Response'];
      print(countries_data[0]);
      _save_data(countries_data, COUNTRIES_KEY);
    }
    _MapCountries = countries_data;
    setState(() {
      _countrydropDownMenuItems = _getCountryDropDownMenuItems(countries_data);
      _currentCountry = _default_ip_data == null ? "" : _default_ip_data['cc'];
    });
  }

  Future<dynamic> _getUserIpInfo() async {
    var res = await widget.model.getMyExtIpInfo();
    print(res);
    Map ip_data;
    if (!res['status']) {
      ip_data = await _get_last_info(
          IP_KEY, "Nous allons utilisé votre derniere position");
    } else {
      ip_data = res['msg'];
      _save_data(ip_data, IP_KEY);
    }

    print("final result is $ip_data");

    return ip_data;
  }

  _save_data(data, String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(data));
  }

  _get_last_info(key, msg) async {
    print('check ${key} from SharedPreferences');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String data = prefs.getString(key);
    if (data != null) {
      if (msg != "") {
        showSnackBar(context, msg, status: false);
      }
      return json.decode(data);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[_bodyContent(context), _loadingSpinner()],
        ),
      ),
    );
  }

  Widget _bodyContent(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          /*title: Text(
            _appBarText,
            style: TextStyle(fontSize: 18),
          ),*/
          backgroundColor: Colors.grey[100],
          expandedHeight: 150.0,
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
              SizedBox(
                height: 20,
              ),
              Column(
                children: <Widget>[
                  _countryDropDown(),
                ],
              ),
              Container(color: Colors.grey.withOpacity(0.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _countryDropDown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: DropdownButtonHideUnderline(
              child: SizedBox(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: new DropdownButton(
                    isExpanded: true,
//                              style: Theme.of(context).textTheme.title,
                    hint: new Text("Chosir Pays"),
                    value: _currentCountry,
                    items: _countrydropDownMenuItems,
                    onChanged: _countryChangedDropDownItem,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _loadingSpinner() {
    return Visibility(
      visible: _loading ?? true,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white.withOpacity(0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              SizedBox(height: 10),
              Text("chargement")
            ],
          ),
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _getCountryDropDownMenuItems(List countries) {
    List<DropdownMenuItem<String>> items = new List();

    for (var val in countries) {
      var country = val;
      print('country data :  ${val['Flag']}');

      /*  var leadingIc = Image.network(
        country['Flag'],
        width: 30,
      );*/

      items.add(new DropdownMenuItem(
          value: country['Alpha2Code'],
          child: Row(
            children: <Widget>[
//              leadingIc,
              SizedBox(
                width: 10,
              ),
              new Text(country['Name']),
            ],
          )));
    }
    return items;
  }

  void _countryChangedDropDownItem(String selected) {
    var operatorsFound = [];
    setState(() {});

    var mapCountry = _MapCountries.firstWhere((i) => i['name'] == selected,
        orElse: () => null);

    if (mapCountry != null) {}

    setState(() {
      _currentCountry = selected;
    });
  }
}
