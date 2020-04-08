import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/utils/style.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../widgets/send_receive_switch.dart';
import '../widgets/transaction.dart';
import '../widgets/custom_button.dart';

class Dashboard extends StatefulWidget {
  final MainModel model;

  const Dashboard({Key key, this.model}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with AfterLayoutMixin<Dashboard> {
  StreamSubscription<LocationData> locationSubscription;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    widget.model.initLocation().then((_) {
//      print('init location listener');
//      _locationListener();
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _anonymeAuthenticate(context);
  }

  void _anonymeAuthenticate(BuildContext context) async {
    setState(() {
      _loading = true;
    });

    var connected = widget.model.aconnected;
    print('checking connected....$connected');

    if (!connected) {
      var authentification = await widget.model.anonymousAuth();
      print('auth res $authentification');
      checkErrorMessge(authentification);
      if (authentification['status']) {
        _getTransactions();
      }
    } else {
      _getTransactions();
    }
  }

  _locationListener() {
    locationSubscription = widget.model.location.onLocationChanged
        .listen((LocationData currentLocation) {
      print('new location ${currentLocation.toString()}');
    });
  }

  _getTransactions() async {
    setState(() {
      _loading = true;
    });
    var url = '${baseurl}auth/api_keys/${API_Key}/transaction/1';
    var res = await widget.model.get_api(url, true);
    print('trans res $res');
    checkErrorMessge(res);

    if (res['status']) {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    if (locationSubscription != null) {
      locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacementNamed(context, "/");
        return;
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(21),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              colors: DASHBOARD_GRADIENT,
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "Cher Donateur,",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                      /*Text(
                                        "What would you do like to do today ?",
                                        style: TextStyle(color: Colors.white),
                                      ),*/
                                    ],
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 5.0,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                      shape: BoxShape.circle,
                                      color: Colors.transparent,
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        USER_PROFILE_ASSET,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25.0,
                              ),
                              SendReceiveSwitch(),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 45),
                          color: Color(0xfff4f5f9),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Flexible(
                                child:
                                    CustomButton(buttonType: ButtonType.donate),
                              ),
                              Flexible(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/all-transactions");
                                    },
                                    child: CustomButton(
                                        buttonType: ButtonType.history)),
                              ),
                              Flexible(
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pushNamed(context, "/help");
                                    },
                                    child: CustomButton(
                                        buttonType: ButtonType.help)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(21.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Text(
                            "TRANSACTIONS RECENTES",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 17.0,
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/transaction-detail");
                                  },
                                  child: Transaction(
                                    receptient: "Amazigh Halzoun",
                                    transactionAmout: "5000.00",
                                    transactionDate: "26 Jun 2019",
                                    transactionInfo: "Laptop",
                                    transactionType: TransactionType.sent,
                                  ),
                                ),
                                Transaction(
                                  receptient: "Awesome Client",
                                  transactionAmout: "15000.00",
                                  transactionDate: "26 Jun 2019",
                                  transactionInfo: "Mobile App",
                                  transactionType: TransactionType.pending,
                                ),
                                Transaction(
                                  receptient: "Lazy Client",
                                  transactionAmout: "25000.00",
                                  transactionDate: "24 Jun 2019",
                                  transactionInfo: "Mobile App",
                                  transactionType: TransactionType.sent,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              LoadingSpinner(
                loading: _loading,
              )
            ],
          ),
          /* bottomNavigationBar: buildBottomNavigationBar(context),*/
        ),
      ),
    );
  }

  BottomNavigationBar buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor: Theme.of(context).primaryColor,
      selectedItemColor: Theme.of(context).primaryColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          title: Text("History"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          title: Text("Notifications"),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text("Settings"),
        ),
      ],
    );
  }

  checkErrorMessge(res) {
    setState(() {
      _loading = false;
    });
    if (!res['status']) {
      var msg = res.containsKey('msg')
          ? res['msg']
          : "Une Erreur s'est produite. Veuillez contacter l'Admin";
      showSnackBar(context, msg, status: false, duration: 5);

      //      Navigator.of(_scaffoldKey.currentContext).pop(msg);
    }
  }
}
