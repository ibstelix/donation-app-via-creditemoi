import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';

class BanksSelector extends StatefulWidget {
  final MainModel model;

  const BanksSelector({Key key, this.model}) : super(key: key);

  @override
  _BanksSelectorState createState() => _BanksSelectorState();
}

class _BanksSelectorState extends State<BanksSelector> {
  String _appBarText = "Etape 2";
  bool _loading = false;
  int _selected_bank_index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            _bodyContent(context),
            LoadingSpinner(
              loading: _loading,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          elevation: 2,
          child: Icon(
            Icons.arrow_forward,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            if (_selected_bank_index == null) {
              showSnackBar(context, "Veuillez d'abord choisir une banque",
                  duration: 5);
              return;
            }
            widget.model.selected_bank_id = _selected_bank_index;
          },
        ),
      ),
    );
  }

  Widget _bodyContent(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          backgroundColor: HexColor.fromHex("#062b66"),
          expandedHeight: 150.0,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(_appBarText),
            background: Image.asset(FORM_BACKGROUND_ASSET, fit: BoxFit.cover),
          ),
        ),
        SliverList(
//          itemExtent: 100.0,
          delegate: SliverChildListDelegate(
            [
              SizedBox(
                height: 40,
              ),
              _title(),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selected_bank_index = index;
                      });
                    },
                    child: ListTile(
                      title: _cardView(index),
                    ),
                  );
                },
              ),
              Container(color: Colors.grey.withOpacity(0.3)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Choisir une Banque",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.0),
              ),
              /*IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )*/
            ],
          ),
        ),
      ],
    );
  }

  Container _cardView(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: _boxDecorationSelected(index),
//      alignment: Alignment.center,
      child: Row(
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                "assets/banks_mean.png",
                width: 40,
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Container(
              padding: EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Bank of Money",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "TownTown",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _boxDecorationSelected(int index) {
    return BoxDecoration(
      border: Border.all(
        color: _selected_bank_index == index ? Colors.blue : Colors.transparent,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );
  }
}
