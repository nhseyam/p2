import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  double _totalAmnt = 0;
  double get totalAmnt => _totalAmnt;
  display(double no) async {
    _totalAmnt = no;
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
