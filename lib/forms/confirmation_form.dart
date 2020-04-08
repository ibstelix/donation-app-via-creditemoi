import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

class ConfirmationForm extends StatefulWidget {
  final MainModel model;
  final String type;

  const ConfirmationForm({Key key, this.type, this.model}) : super(key: key);

  @override
  _ConfirmationFormState createState() => _ConfirmationFormState();
}

class _ConfirmationFormState extends State<ConfirmationForm>
    with AfterLayoutMixin<ConfirmationForm> {
  String _appBarText = "Confirmation";
  bool _loading = false;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<LocationData> locationSubscription;
  LocationData _currentLocation;
  Map _deviceData = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
    print("selected ${widget.model.selected_country}");
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _getUSerIDData();
  }

  _initLocation() {
    widget.model.initLocation().then((_) {
      _currentLocation = widget.model.currentLocation;
      print('init location listener whith ${_currentLocation.toString()}');
      _locationListener();
    });
  }

  _locationListener() {
    locationSubscription = widget.model.location.onLocationChanged
        .listen((LocationData currentLocation) {
      _currentLocation = currentLocation;
//      print('new location ${currentLocation.toString()}');
    });
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
              SizedBox(
                height: 50,
              ),
              _mainView(),
              SizedBox(
                height: 50.0,
              ),
              new Container(
                alignment: Alignment.center,
                child: _getPayButton(),
              ),
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

  Widget _mainView() {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        _ReceiverSection(),
        Divider(
          height: 2,
        ),
        SizedBox(
          height: 20,
        ),
        _AmountSection(),
        Divider(
          height: 2,
        ),
        _BankCardSection()
      ],
    );
  }

  Widget _ReceiverSection() {
    var receiver = widget.type;
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              child: Text(receiver.substring(0, 1)),
            ),
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Paiement par $receiver",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SvgPicture.network(
                      widget.model.selected_country['Flag'],
                      width: 20,
                    ),
                  ),
                  Text(
                    widget.model.selected_country['Name'],
                    style: TextStyle(fontSize: 12.0, color: Color(0xFF929091)),
                  ),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }

  Widget _AmountSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
      child: Card(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(11.0))),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0),
                child: Text(
                  'Montant de la donation',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '\$',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        "${widget.model.amount}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.0,
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _BankCardSection() {
    return Container(
//      color: Colors.yellow,
      margin: EdgeInsets.all(16.0),
//      height: 200.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Text(
                    'Debité de',
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          Card(
            margin: EdgeInsets.all(0.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(11.0))),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 26.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      widget.type == "Mobile"
                          ? Icons.dialpad
                          : Icons.credit_card,
                      color: Colors.blue,
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        widget.type == "Mobile"
                            ? widget.model.phone_number
                            : bankCardNumberFormat(
                                widget.model.paymentCard.number),
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _validateInputs() {
    FocusScope.of(context).requestFocus(new FocusNode());

    if (widget.type == "Bank") {
      showSnackBar(
          context, "Le paiement par banque n'est pas encore disponible",
          status: false);
      return;
    }

    print('current location i s $_currentLocation');
    if (_currentLocation == null) {
      showFormValidationToast(
          'La localisation n\'est pas pris en compte\nVeuillez patienter');
      _initLocation();
      return;
    } else {
      _facturatioProcess();
    }
  }

  _facturatioProcess() async {
    setState(() {
      _loading = true;
    });

    var selectedOperator = widget.model.selectedOperator ?? {};
//    print("operator ${widget.model.selectedOperator}");

    var api_key = API_Key;

    Map<String, dynamic> sendData = {
      'api_key': api_key,
      'service_items_id': selectedOperator['id'].toString() ?? '0',
      'phone_number': widget.model.phone_number.toString(),
      'amount': widget.model.amount.toString(),
      "custom_data": json.encode({
        "external_id": _deviceData['userID'],
        'location': {
          'lat': _currentLocation.latitude,
          'long': _currentLocation.longitude
        },
        "device_id": _deviceData['deviceID'],
        "ext_transaction_ID": _deviceData['ext_transaction_ID']
      })
    };

    print('data to send : ${sendData}');
    var url = '${baseurl}credit/send';

    var status = await widget.model.post_api(sendData, url, true);
    print('status ::  ${status}');

    if (status != null) {
      setState(() {
        _loading = false;
      });
      bool st = status['status'] ?? false;

      if (!st) {
        _handleErrorRequest(status);
      } else {
        showSnackBar(context, "Facturation reussie", status: true, duration: 5);
        _livraisonProcess();
      }
    }
  }

  _livraisonProcess() async {
    setState(() {
      _loading = true;
    });
    var selectedOperator = widget.model.selectedOperator ?? {};

    var api_key = API_Key;
    Map<String, dynamic> sendData = {
      'api_key': api_key,
      'service_items_id': selectedOperator['id'].toString() ?? '0',
      'phone_number': DONATION_PHONE,
      'amount': widget.model.amount.toString(),
      "custom_data": json.encode({
        "external_id": _deviceData['userID'],
        'location': {
          'lat': _currentLocation.latitude,
          'long': _currentLocation.longitude
        },
        "device_id": _deviceData['deviceID'],
        "ext_transaction_ID": _deviceData['ext_transaction_ID']
      })
    };

    var url = '${baseurl}credit/send';

    var status = await widget.model.post_api(sendData, url, true);
    print('status ::  ${status}');

    if (status != null) {
      setState(() {
        _loading = false;
      });
      bool st = status['status'] ?? false;

      if (!st) {
        _handleErrorRequest(status);
      } else {
        showFormValidationToast("Donation reussie", Colors.green);
        Navigator.of(context).pushReplacementNamed("/home");
      }
    }
  }

  _getUSerIDData() async {
    print('get device info...');
    var checkOS =
        Theme.of(context).platform == TargetPlatform.iOS ? 'iOS' : 'Android';

    var userData = await widget.model.getDeviceUserID(checkOS);
    _deviceData = userData;
    print("userdata found is $userData");
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

  void _handleErrorRequest(Map status) {
    print('error status is $status');
    var msg = status.containsKey('msg')
        ? (status['msg'] != null ? status['msg'] : 'Erreur Http Inattendue')
        : "Une erreur inattendue s'est produit";
    status['msg'] = msg;
    showSnackBar(context, msg, status: false, duration: 5);
  }
}
