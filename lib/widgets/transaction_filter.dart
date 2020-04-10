import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;

class TransactionFilter extends StatefulWidget {
  @override
  _TransactionFilterState createState() => _TransactionFilterState();
}

class _TransactionFilterState extends State<TransactionFilter> {
  double _padding = 16.0;

  double _avatarRadius = 66.0;

  Map _result;

  var _phoneController = new TextEditingController();

  List<DropdownMenuItem<String>> _typeMenuItems;

  String _currentType;

  DateTime _datePickerValue = new DateTime.now();

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
    return Container(
//      height: 200,
      padding: EdgeInsets.only(
        top: _padding,
        bottom: _padding,
        left: _padding,
        right: _padding,
      ),
      margin: EdgeInsets.only(top: _avatarRadius),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(_padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _title(),
          SizedBox(
            height: 40,
          ),
          _datePickerField(context),
          SizedBox(height: 24.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: _typesDropDown(),
          ),
          SizedBox(height: 24.0),
          _phoneInput(),
          SizedBox(height: 24.0),
          _actionButtons(context)
        ],
      ),
    );
  }

  Widget _title() {
    return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          "Filtre",
          style: TextStyle(color: Colors.blue),
        ));
  }

  Future _showDatePicker(context) async {
    final List<DateTime> picked = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: new DateTime.now(),
        initialLastDate: new DateTime.now(),
        firstDate: new DateTime(2015),
        lastDate: DateTime.now().add(Duration(days: 360)));
    if (picked != null && picked.length == 2) {
      print(picked);
//      setState(() {
//        _datePickerValue=picked;
//      });
    }

    /*DateTime picked = await showDatePicker(
      context: context,
      initialDate: _datePickerValue,
      firstDate: DateTime.now().subtract(Duration(days: 30 * 12 * 100)),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );
    if (picked != null)
      setState(() {
        var newFormat = new DateFormat("ddMMyyyy").format(picked);
        print('datetime picked is ${newFormat}');
        _datePickerValue = picked;
//        _datePickerValue = picked.toString();
//        _datePickerValue = new DateFormat("dd-MM-yyyy").format(picked);
      });*/
  }

  Widget _datePickerField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.all(5),
          margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
          child: Row(
            children: <Widget>[
              new Expanded(
                child: GestureDetector(
                  onTap: () {
                    _showDatePicker(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        errorStyle: TextStyle(fontSize: 8),
                        hintText: 'Choisir une date',
                        labelText: 'Date',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _typesDropDown() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                /*border: Border.all(
                color: Colors.grey.withOpacity(0.5),
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),*/
                ),
            child: SizedBox(
              child: ButtonTheme(
                alignedDropdown: true,
                child: new DropdownButton(
                  isExpanded: true,
                  hint: new Text("Status"),
                  value: _currentType,
                  items: _typeMenuItems,
                  onChanged: _typeChangeListener,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _phoneInput() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        controller: _phoneController,
        inputFormatters: [
          WhitelistingTextInputFormatter.digitsOnly,
        ],
        decoration: new InputDecoration(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.withOpacity(0.4)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.withOpacity(0.4)),
          ),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey.withOpacity(0.05),
//        icon: Icon(Icons.phone),
          hintText: 'Numero de telephone',
          labelText: 'Telephone',
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Row(
          children: <Widget>[
            Expanded(
                child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: Text('Fermer'),
            )),
            Expanded(
                child: MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(_result);
              },
              child: Text('Soumettre'),
            ))
          ],
        ),
      ),
    );
  }

  void _typeChangeListener(String selected) {
    _currentType = selected;
  }
}
