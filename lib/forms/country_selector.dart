import 'dart:convert';

import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/custom_button.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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
  Map _selected_country;

  List<DropdownMenuItem<String>> _countrydropDownMenuItems;
  String _currentCountryCode;

  List<DropdownMenuItem<String>> _operatorTypedropDownMenuItems;
  String _currentOperatorType;
  int _selected_operator_index;

  List _MapCountries = [];
  List _operatorsTypes = ["banks", "mobile"];

  String _payment_method = 'Methode de Paiement';

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
        _initSelectedCountry();
        _loading = false;
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

      _initSelectedCountry();

      _loading = false;
    });
  }

  _initSelectedCountry() {
    if (_default_ip_data != null) {
      _currentCountryCode = _default_ip_data['cc'];

      var mapCountry = _MapCountries.firstWhere(
          (i) => i['Alpha2Code'].toUpperCase() == _currentCountryCode,
          orElse: () => null);

      print("curr $_currentCountryCode and $mapCountry");

      if (mapCountry != null) {
        _selected_country = mapCountry;
      }
    } else {
      _currentCountryCode = "";
    }
  }

  Future<dynamic> _getUserIpInfo() async {
    setState(() {
      _loading = true;
    });
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
        showSnackBar(context, msg, status: false, duration: 5);
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
            if (_currentCountryCode == null) {
              showSnackBar(
                  context, "Veuillez d'abord choisir votre pays de residence");
              return;
            }

            if (_selected_operator_index == null) {
              showSnackBar(
                  context, "Veuillez d'abord choisir une methode de paiement",
                  duration: 5);
              return;
            }

            print('selected country $_selected_country');

            widget.model.selected_country_code = _currentCountryCode;
            widget.model.selected_country = _selected_country;
            var selected_op_type = _operatorsTypes[_selected_operator_index];
            widget.model.selected_operator_type = selected_op_type;
            Navigator.pushNamed(context, "/$selected_op_type");
          },
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
              SizedBox(
                height: 40,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _countryDropDown(),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text(_payment_method,
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 18,
                            color: Colors.black)),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Divider(
                    height: 2,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Flexible(
                            child: InkWell(
                          onTap: () =>
                              setState(() => _selected_operator_index = 0),
                          child: Container(
                              decoration: _boxDecorationSelected(0),
                              child:
                                  CustomButton(buttonType: ButtonType.banks)),
                        )),
                        Flexible(
                            child: InkWell(
                          onTap: () =>
                              setState(() => _selected_operator_index = 1),
                          child: Container(
                              decoration: _boxDecorationSelected(1),
                              child:
                                  CustomButton(buttonType: ButtonType.mobile)),
                        ))
                      ],
                    ),
                  )
                ],
              ),
              Container(color: Colors.grey.withOpacity(0.3)),
            ],
          ),
        ),
      ],
    );
  }

  _boxDecorationSelected(int index) {
    return BoxDecoration(
      border: Border.all(
        color: _selected_operator_index == index
            ? Colors.blue
            : Colors.transparent,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
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
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: DropdownButtonHideUnderline(
              child: SizedBox(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: new DropdownButton(
                    isExpanded: true,
//                              style: Theme.of(context).textTheme.title,
                    hint: new Text("Chosir Pays"),
                    value: _currentCountryCode,
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

  List<DropdownMenuItem<String>> _getCountryDropDownMenuItems(List countries) {
    List<DropdownMenuItem<String>> items = new List();

    for (var val in countries) {
      var country = val;
//      print('country data :  ${val['Flag']}');

      var leadingIc = SvgPicture.network(
        country['Flag'],
        width: 30,
      );

      items.add(new DropdownMenuItem(
          value: country['Alpha2Code'],
          child: Row(
            children: <Widget>[
              leadingIc,
              SizedBox(
                width: 10,
              ),
              new Text(country['Name'], overflow: TextOverflow.ellipsis),
            ],
          )));
    }
    return items;
  }

  void _countryChangedDropDownItem(String selected) {
    setState(() {});

    var mapCountry = _MapCountries.firstWhere(
        (i) => i['Alpha2Code'] == selected,
        orElse: () => null);

    if (mapCountry != null) {
      _selected_country = mapCountry;
      setState(() {
        _currentCountryCode = selected;
      });
    }
  }
}
