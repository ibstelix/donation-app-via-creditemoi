import 'package:codedecoders/scope/main_model.dart';
import 'package:flutter/material.dart';

class ItemToBuyCard extends StatefulWidget {
  final Map data;
  final bool checked;
  final BuildContext context;
  final MainModel model;

  ItemToBuyCard(
      {Key key, this.data, this.context, this.model, this.checked: false})
      : super(key: key);

  @override
  _ItemToBuyCardState createState() => _ItemToBuyCardState();
}

class _ItemToBuyCardState extends State<ItemToBuyCard> {
//  AppLocalizations _trans;
  var _langs;

  _translateConfig() {
    setState(() {
      /* _langs = EasyLocalizationProvider.of(context).data;
      _trans = AppLocalizations.of(context);*/
    });
  }

  _boxDecorationSelected() {
    return BoxDecoration(
      border: Border.all(
        color: widget.checked ? Colors.blue : Colors.transparent,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    _translateConfig();
    return Container(
        height: 100,
//        color: Colo/rs.grey,
        padding: EdgeInsets.all(2.0),
//        margin: EdgeInsets.symmetric(horizontal: 5),
        decoration: _boxDecorationSelected(),
        child: Card(
            elevation: 0,
            child: Hero(
                tag: widget.data['id'],
                child: Stack(
                  children: <Widget>[
                    Material(
//                        elevation: 0,
//                        shadowColor: Colors.red,
                        child: GridTile(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Image.network(
                          widget.data['image'],
                          fit: BoxFit.contain,
                        ),
                      ),
                      footer: Container(
                        color: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.data['name'],
                              textAlign: TextAlign.center,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0),
                            )
                          ],
                        ),
                      ),
                    )),
                    /* Align(
                      alignment: Alignment.topRight,
                      child: Visibility(
                        visible: widget.checked,
                        child: Icon(
                          Icons.check_box,
                          color: Colors.green,
                          size: 20,
                        ),
                      ),
                    ),*/
                  ],
                ))));
  }
}
