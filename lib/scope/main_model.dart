import 'package:scoped_model/scoped_model.dart';

import 'api_scope.dart';
import 'form_scope.dart';

class MainModel extends Model with ApiScope, FormScope {}
