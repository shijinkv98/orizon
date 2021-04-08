import 'package:flutter/material.dart';

class DateChangeNotifier extends ChangeNotifier {
  void dateSelected() {
    notifyListeners();
  }
}

class ReportLoadingNotifier extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void setIsLoading(bool loading) {
    _isLoading = loading;
  }

  void reset() {
    _isLoading = false;
  }
}
