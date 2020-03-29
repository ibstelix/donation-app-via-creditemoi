import 'package:flutter/material.dart';

import '../main.dart';

class CustomButton extends StatelessWidget {
  final ButtonType buttonType;

  const CustomButton({Key key, this.buttonType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String buttonText = "", buttonImage;
    switch (buttonType) {
      case ButtonType.payBills:
        buttonText = "Pay Bills";
        buttonImage = "assets/receipt.png";
        break;
      case ButtonType.donate:
        buttonText = "Banques";
        buttonImage = "assets/bank.png";
        break;
      case ButtonType.receiptients:
        buttonText = "Beneficiaires";
        buttonImage = "assets/multi_users.png";
        break;
      case ButtonType.offers:
        buttonText = "Offers";
        buttonImage = "assets/discount.png";
        break;
      case ButtonType.help:
        buttonText = "Help";
        buttonImage = "assets/help_icon.png";
        break;
      case ButtonType.history:
        buttonText = "Historique";
        buttonImage = "assets/history.png";
        break;
    }
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(17),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  gradient: LinearGradient(
                    colors: [Colors.white10, Colors.black12],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Image.asset(
                  buttonImage,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              FittedBox(
                child: Text(buttonText),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
