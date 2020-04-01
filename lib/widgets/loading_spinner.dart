import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final bool loading;

  LoadingSpinner({Key key, this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: loading ?? true,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          color: Colors.white.withOpacity(0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
              SizedBox(height: 10),
              Text("chargement")
            ],
          ),
        ),
      ),
    );
  }
}
