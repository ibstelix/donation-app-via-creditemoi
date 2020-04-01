import 'package:codedecoders/utils/general.dart';
import 'package:flutter/material.dart';

import 'banks_selector.dart';

class SendScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Money"),
        centerTitle: true,
        backgroundColor: HexColor.fromHex("#2b66bd"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Choisir Destinataire",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, payees) {
                  return ListTile(
                    title: Text(''),
                    onTap: () {},
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
