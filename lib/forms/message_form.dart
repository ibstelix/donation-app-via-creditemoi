import 'package:after_layout/after_layout.dart';
import 'package:codedecoders/scope/main_model.dart';
import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/loading_spinner.dart';
import 'package:flutter/material.dart';

class MessageForm extends StatefulWidget {
  final MainModel model;

  const MessageForm({Key key, this.model}) : super(key: key);

  @override
  _MessageFormState createState() => _MessageFormState();
}

class _MessageFormState extends State<MessageForm>
    with AfterLayoutMixin<MessageForm> {
  bool _loading = false;
  String _loadingText = "Initialisation";

  var _formKey = new GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _messageController = new TextEditingController();

  @override
  void afterFirstLayout(BuildContext context) {
    _anonymeAuthenticate(context);
  }

  void _anonymeAuthenticate(BuildContext context) async {
    var connected = widget.model.aconnected;
    print('checking connected....$connected');

    if (!connected) {
      setState(() {
        _loading = true;
      });

      var authentification = await widget.model.anonymousAuth();
      print('auth res $authentification');
      _handleErrorRequest(authentification);
    }
  }

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
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                if (!_formKey.currentState.validate()) {
                  return;
                }

                setState(() {
                  _loadingText = "Envoie en cours";
                });

                _sendMessage();
              },
            ),
          ],
        ),
        resizeToAvoidBottomPadding: true,
        body: Stack(
          children: <Widget>[
            _bodyContent(context),
            LoadingSpinner(
              loading: _loading,
              text: _loadingText,
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
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Champ obligatoire';
                  }

                  return null;
                },
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
                    errorBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.4)),
                    ),
                    focusedErrorBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.white.withOpacity(0.4)),
                    )),
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

  void _sendMessage() async {
    setState(() {
      _loading = true;
    });
    var message = _messageController.text;
    var checkOS =
        Theme.of(context).platform == TargetPlatform.iOS ? 'iOS' : 'Android';
    var anon_data = await widget.model.getDeviceUserID(checkOS);
    print('anon_data $anon_data');
//    var trans_id = anon_data['ext_transaction_ID'].substring(8);
    var trans_id = new DateTime.now().millisecondsSinceEpoch;
    var sendData = {
      "description": message,
      "transaction_id": trans_id.toString()
    };
    var url = '${baseurl}auth/claims';

    var res = await widget.model.post_api(sendData, url, true);

    setState(() {
      _loading = false;
    });
    bool st = res['status'] ?? false;

    if (!st) {
      _handleErrorRequest(res);
    } else {
      showFormValidationToast("Message envoyé", Colors.green);
    }
  }

  void _handleErrorRequest(Map res) {
    setState(() {
      _loading = false;
    });
    if (!res['status']) {
      var msg = res.containsKey('msg')
          ? (res['msg'] != null ? res['msg'] : 'Erreur Http Inattendue')
          : "Une erreur inattendue s'est produit";
      showSnackBar(context, msg, status: false, duration: 6);
    }
  }
}
