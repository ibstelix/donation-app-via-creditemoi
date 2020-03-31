import 'package:flutter/material.dart';

import '../main.dart';

class Transaction extends StatelessWidget {
  final TransactionType transactionType;
  final String transactionAmout, transactionInfo, transactionDate, receptient;

  const Transaction(
      {Key key,
      this.transactionType,
      this.transactionAmout,
      this.transactionInfo,
      this.transactionDate,
      this.receptient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String transactionName;
    IconData transactionIconData;
    Color color;
    switch (transactionType) {
      case TransactionType.sent:
        transactionName = "Sent";
        transactionIconData = Icons.arrow_upward;
        color = Colors.green;
        break;
      case TransactionType.received:
        transactionName = "Received";
        transactionIconData = Icons.arrow_downward;
        color = Colors.green;
        break;
      case TransactionType.pending:
        transactionName = "Pending";
        transactionIconData = Icons.arrow_downward;
        color = Colors.orange;
        break;
    }
    return Container(
      margin: EdgeInsets.all(9.0),
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey[350],
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    "assets/donate_coin.png",
                    width: 50,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 15.0,
                    height: 15.0,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    child: FittedBox(
                      child: Icon(
                        transactionIconData,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 10.0),
          Flexible(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      receptient,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$ $transactionAmout",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "$transactionInfo - $transactionDate",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    Text(
                      "$transactionName",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
