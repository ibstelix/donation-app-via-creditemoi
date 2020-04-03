import 'package:codedecoders/widgets/payment_card.dart';
import 'package:scoped_model/scoped_model.dart';

class FormScope extends Model {
  String _selected_country_code;
  String _selected_operator_type;
  int _selected_bank_id;

  PaymentCard _paymentCard;

  PaymentCard _card;

  bool _aconnected = false;
  Map _anonymous_user;
  List _aServiceProviders = [];

  Map _selectedOperator;

  Map _selectedItem;

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
}
