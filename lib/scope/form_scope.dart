import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/payment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';

class FormScope extends Model {
  String _selected_country_code;
  Map _selected_country;

  String _selected_operator_type;
  int _selected_bank_id;

  PaymentCard _paymentCard;

  PaymentCard _card;

  bool _aconnected = false;
  Map _anonymous_user;
  List _aServiceProviders = [];

  Map _selectedOperator;

  Map _selectedItem;

  double _amount;
  String _phone_number;

  PublishSubject<dynamic> _locationSubject = PublishSubject();
  Location _location = new Location();
  LocationData _currentLocation;

  Future<LocationData> getUserLocation() async {
//    _location.hasPermission();
    var currentLocation;
    try {
      currentLocation = await _location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        showFormValidationToast(
            'Impossible de recuperer la localisation', Colors.red);
      }
      currentLocation = null;
    }
    _currentLocation = currentLocation;
    notifyListeners();
    return _currentLocation;
  }

  Future<bool> checkLocationPermission() async {
    var gps = await _location.serviceEnabled();
    if (gps) {
      return true;
    } else {
      var reqGPS = await _location.requestService();
      if (reqGPS) {
        return true;
      }
    }
    return false;
  }

  Future<LocationData> initLocation() async {
    var checkPermission = await checkLocationPermission();

    if (!checkPermission) {
      showFormValidationToast(NO_LOCATION_SERVICE);
      return null;
    }

    var permCheck = await _location.requestPermission();
    print('check curentLocation is $_currentLocation / $permCheck');

    if (permCheck != null) {
      var locationStatus = await getUserLocation();
      print('location status is $locationStatus');
      if (locationStatus == null) {
        showFormValidationToast(NO_LOCATION_SERVICE);
        notifyListeners();
        return null;
      }
      _currentLocation = locationStatus;
    }
    notifyListeners();
    return _currentLocation;
  }

  /**
   * GETTER AND SETTER
   */

  Map get selected_country => _selected_country;

  set selected_country(Map value) {
    _selected_country = value;
    notifyListeners();
  }

  double get amount => _amount;

  set amount(double value) {
    _amount = value;
    notifyListeners();
  }

  Map get selectedOperator => _selectedOperator;

  set selectedOperator(Map value) {
    _selectedOperator = value;
    notifyListeners();
  }

  List get aServiceProviders => List.from(_aServiceProviders);

  set aServiceProviders(List value) {
    _aServiceProviders = value;
    notifyListeners();
  }

  Map get anonymous_user => _anonymous_user;

  set anonymous_user(Map value) {
    _anonymous_user = value;
    notifyListeners();
  }

  bool get aconnected => _aconnected;

  set aconnected(bool value) {
    _aconnected = value;
    notifyListeners();
  }

  PaymentCard get paymentCard => _paymentCard;

  set paymentCard(PaymentCard value) {
    _paymentCard = value;
    notifyListeners();
  }

  int get selected_bank_id => _selected_bank_id;

  set selected_bank_id(int value) {
    _selected_bank_id = value;
    notifyListeners();
  }

  String get selected_country_code => _selected_country_code;

  set selected_country_code(String value) {
    _selected_country_code = value;
    notifyListeners();
  }

  String get selected_operator_type => _selected_operator_type;

  set selected_operator_type(String value) {
    _selected_operator_type = value;
    notifyListeners();
  }

  PaymentCard get card => _card;

  set card(PaymentCard value) {
    _card = value;
    notifyListeners();
  }

  Map get selectedItem => _selectedItem;

  set selectedItem(Map value) {
    _selectedItem = value;
    notifyListeners();
  }

  String get phone_number => _phone_number;

  set phone_number(String value) {
    _phone_number = value;
    notifyListeners();
  }

  Location get location => _location;

  set location(Location value) {
    _location = value;
    notifyListeners();
  }

  LocationData get currentLocation => _currentLocation;

  set currentLocation(LocationData value) {
    _currentLocation = value;
    notifyListeners();
  }

  PublishSubject<dynamic> get locationSubject => _locationSubject;

  set locationSubject(PublishSubject<dynamic> value) {
    _locationSubject = value;
    notifyListeners();
  }
}
