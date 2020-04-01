import 'package:alice/alice.dart';
import 'package:codedecoders/dashboard.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/screens/banks_selector.dart';
import 'package:codedecoders/screens/card_form.dart';
import 'package:codedecoders/screens/country_selector.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'homePage.dart';
import 'login.dart';

void main() => runApp(MyApp());

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Alice alice = Alice(showNotification: true, navigatorKey: navigatorKey);

enum ButtonType {
  payBills,
  donate,
  banks,
  mobile,
  receiptients,
  offers,
  help,
  history
}
enum TransactionType { sent, received, pending }

class MyApp extends StatelessWidget {
  final MainModel _model = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (BuildContext context) => Login(
                model: _model,
              ),
          '/home': (BuildContext context) => Dashboard(
                model: _model,
              ),
          '/country': (BuildContext context) => CountrySelector(
                model: _model,
              ),
          '/banks': (BuildContext context) => BanksSelector(
                model: _model,
              ),
          '/mobile': (BuildContext context) => BanksSelector(
                model: _model,
              ),
          '/card-form': (BuildContext context) => CardForm(
                model: _model,
              ),
        },
      ),
    );
  }
}
