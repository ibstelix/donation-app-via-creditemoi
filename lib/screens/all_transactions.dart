import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:codedecoders/widgets/transaction.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AllTransactions extends StatefulWidget {
  final MainModel model;

  const AllTransactions({Key key, this.model}) : super(key: key);

  @override
  _AllTransactionsState createState() => _AllTransactionsState();
}

class _AllTransactionsState extends State<AllTransactions> {
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Votre Historique',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
              size: 25,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _bodyContent(context),
            LoadingSpinner(
              loading: _loading,
            )
          ],
        ));
  }

  _bodyContent(BuildContext context) {
    return ListView(physics: BouncingScrollPhysics(), children: <Widget>[
      SizedBox(
        height: 40,
      ),
      InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/transaction-detail");
        },
        child: Transaction(
          receptient: "Amazigh Halzoun",
          transactionAmout: "5000.00",
          transactionDate: "26 Jun 2019",
          transactionInfo: "Laptop",
          transactionType: TransactionType.sent,
        ),
      ),
    ]);
  }
}
