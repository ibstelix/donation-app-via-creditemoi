import 'package:codedecoders/strings/const.dart';
import 'package:codedecoders/utils/general.dart';
import 'package:codedecoders/widgets/payment_card.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

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

  int _amount;
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

  Future<AndroidDeviceInfo> getIdDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo;
  }

  Future<IosDeviceInfo> getAppleIdDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo;
  }

  getDeviceUserID(String OS) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userID = prefs.getString('userID');
    String deviceID = prefs.getString('devide_id');
    String ext_transaction_ID = '';
//    int timestamp = DateTime.now().millisecondsSinceEpoch;
    var uuid = Uuid();
    if (userID == null || deviceID == null || ext_transaction_ID == null) {
      if (OS == 'iOS') {
        var apple = await getAppleIdDeviceInfo(); //identifierForVendor
        deviceID = apple.identifierForVendor;

        print('apple ID ${deviceID}');
      } else {
        var android = await getIdDeviceInfo(); //androidId
        deviceID = android.androidId;
        print('Android ID ${deviceID}');
      }
      userID = uuid.v5(Uuid.NAMESPACE_URL, deviceID);
      ext_transaction_ID = uuid.v1();
      print('userID is $userID');

      prefs.setString('devide_id', deviceID);
      prefs.setString('userID', userID);

      return {
        'userID': userID,
        'deviceID': deviceID,
        'ext_transaction_ID': ext_transaction_ID
      };
    } else {
      ext_transaction_ID = uuid.v1();
      return {
        'userID': userID,
        'deviceID': deviceID,
        'ext_transaction_ID': ext_transaction_ID
      };
    }
  }
  /**
   * GETTER AND SETTER
   */

  Map get selected_country => _selected_country;

  set selected_country(Map value) {
    _selected_country = value;
    notifyListeners();
  }

  int get amount => _amount;

  set amount(int value) {
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
