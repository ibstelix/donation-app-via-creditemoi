import 'package:codedecoders/homePage.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Login extends StatefulWidget {
  final MainModel model;

  const Login({Key key, this.model}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _mainContent(context),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text("hello"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image1.png"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter)),
      child: Form(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 2.15,
            ),
            SizedBox(
              height: 20,
            ),
            _paticipateBtn(),
            SizedBox(
              height: 20,
            ),
            _reportBtn(),
            SizedBox(
              height: 20,
            ),
            _sendMessage(context),
          ],
        ),
      ),
    );
  }

  Widget _sendMessage(BuildContext context) {
    return MaterialButton(
      minWidth: 330,
      height: 70,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: Color(0xff501396), width: 1)),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.mail),
          SizedBox(
            width: 10,
          ),
          Text(
            "Envoyer un message",
            style: TextStyle(
                color: Color(0xff501396),
                fontFamily: "CentraleSansRegular",
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _reportBtn() {
    return Container(
      width: 330,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff471a91),
            Color(0xff3cabff),
            Color(0xff3cabff),
            Color(0xff471a91)
          ],
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              LineAwesomeIcons.pie_chart,
              color: Colors.white,
              size: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Rapports",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "CentraleSansRegular",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paticipateBtn() {
    return Container(
      width: 330,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff471a91), Color(0xff3cabff)],
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              LineAwesomeIcons.money,
              color: Colors.white,
              size: 35,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Participer",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "CentraleSansRegular",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
