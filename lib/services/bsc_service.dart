import 'package:flutter/foundation.dart';

class BscService with ChangeNotifier {
  bool loading = false;
  getUserBalance(String text) async {
    loading = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      loading = false;
      notifyListeners();
    });
  }
}
