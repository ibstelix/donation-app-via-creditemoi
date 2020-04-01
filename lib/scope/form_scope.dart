import 'package:scoped_model/scoped_model.dart';

class FormScope extends Model {
  String _selected_country_code;
  String _selected_operator_type;
  int _selected_bank_id;

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
}
