import 'package:codedecoders/widgets/setting_row_widget.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'A Propos',
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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 40,
          ),
          HeaderWidget(
            'Support',
            secondHeader: false,
          ),
          SettingRowWidget(
            "Contactez-nous au xxxxxx",
            vPadding: 15,
            showDivider: false,
          ),
          HeaderWidget('Equipe de Development'),
          SettingRowWidget(
            "ibstelix Dev Inc.",
            showDivider: true,
          ),
          SettingRowWidget(
            "ibstelix@gmail.com",
            showDivider: true,
          ),
          SettingRowWidget(
            "Senegal",
            showDivider: true,
          ),
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final String title;
  final bool secondHeader;

  const HeaderWidget(this.title, {Key key, this.secondHeader = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: secondHeader
          ? EdgeInsets.only(left: 18, right: 18, bottom: 10, top: 35)
          : EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      color: Colors.grey[100],
      alignment: Alignment.centerLeft,
      child: Text(
        title ?? '',
        style: TextStyle(
            fontSize: 20,
            color: Color(0xff1657786),
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
