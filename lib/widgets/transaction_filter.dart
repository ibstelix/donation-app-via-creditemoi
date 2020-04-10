import 'package:flutter/material.dart';

class TransactionFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Column(
      children: <Widget>[
        _title(),
        SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget _title() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          "Filtre",
          style: TextStyle(color: Colors.blue),
        ));
  }
}
