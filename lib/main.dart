import 'package:alice/alice.dart';
import 'package:codedecoders/screens/dashboard.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/forms/amount_form.dart';
import 'package:codedecoders/forms/banks_selector.dart';
import 'package:codedecoders/forms/card_form.dart';
import 'package:codedecoders/forms/confirmation_form.dart';
import 'package:codedecoders/forms/country_selector.dart';
import 'package:codedecoders/forms/operator_form.dart';
import 'package:codedecoders/screens/transaction_detail.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'screens/login.dart';

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
          '/mobile': (BuildContext context) => OperatorForm(
                model: _model,
              ),
          '/card-form': (BuildContext context) => CardForm(
                model: _model,
              ),
          '/transaction-detail': (BuildContext context) => TransactionDetail(
                model: _model,
              ),
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }

          if (pathElements[1] == 'amount-form') {
            final int step_index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  AmountForm(model: _model, stepIndex: step_index),
            );
          }

          if (pathElements[1] == 'confirmation-form') {
            final String type = pathElements[2];
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  ConfirmationForm(model: _model, type: type),
            );
          }

          return null;
        },
      ),
    );
  }
}
