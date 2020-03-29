import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/utils/style.dart';
import 'package:flutter/material.dart';

import 'main.dart';
import 'widgets/send_receive_switch.dart';
import 'widgets/transaction.dart';
import 'widgets/custom_button.dart';

class Dashboard extends StatefulWidget {
  final MainModel model;

  const Dashboard({Key key, this.model}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Hey User,",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 23),
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
                                backgroundImage: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2017/11/02/14/26/model-2911329_960_720.jpg",
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        SendReceiveSwitch(),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    color: Color(0xfff4f5f9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        /*  Flexible(
                          child: CustomButton(buttonType: ButtonType.payBills),
                        ),*/
                        Flexible(
                          child: CustomButton(buttonType: ButtonType.donate),
                        ),
                        Flexible(
                          child: CustomButton(buttonType: ButtonType.history),
                        ),
                        Flexible(
                          child: CustomButton(buttonType: ButtonType.help),
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
                          Transaction(
                            receptient: "Amazigh Halzoun",
                            transactionAmout: "5000.00",
                            transactionDate: "26 Jun 2019",
                            transactionInfo: "Laptop",
                            transactionType: TransactionType.sent,
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
        /* bottomNavigationBar: buildBottomNavigationBar(context),*/
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
}
