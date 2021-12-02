import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService with ChangeNotifier {
  bool loading = true;
  late SharedPreferences sharedPreferences;
  getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    this.sharedPreferences = sharedPreferences;
    loading = false;
    notifyListeners();
  }
}
