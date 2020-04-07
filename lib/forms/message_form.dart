import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';

class MessageForm extends StatefulWidget {
  final MainModel model;

  const MessageForm({Key key, this.model}) : super(key: key);

  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm> {
  bool _loading = false;

  var _formKey = new GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _messageController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Text(
            'Envoyer un Message',
            style: TextStyle(color: Colors.blue),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.blue,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.blue,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            _bodyContent(context),
            LoadingSpinner(
              loading: _loading,
            )
          ],
        ),
      ),
    );
  }

  _bodyContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: "Saisir votre message",
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.4)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.4)),
                  ),
                ),
                scrollPadding: EdgeInsets.all(20.0),
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                autofocus: true,
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                height: 2,
                thickness: 1,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 900,
                height: 200,
                decoration: new BoxDecoration(
                  image: new DecorationImage(
                    image: new AssetImage("assets/messenger.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
