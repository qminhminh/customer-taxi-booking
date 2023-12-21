import 'package:customer_taxi_booking_app/models/user.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends ChangeNotifier {
  UserCustomer _user = UserCustomer(
    id: '',
    blockStatus: '',
    email: '',
    password: '',
    name: '',
    phone: '',
    photo: '',
    type: '',
    token: '',
  );

  UserCustomer get user => _user;

  void setUser(String user) {
    _user = UserCustomer.fromJson(user);
    notifyListeners();
  }

  void setUserFromModel(UserCustomer user) {
    _user = user;
    notifyListeners();
  }
}
