import 'package:flutter/material.dart';

class DashboardLoadNotifier extends ChangeNotifier {
  bool _isLoading = true;
  bool get isLoading => _isLoading;
  set isLoading(bool duty) {
    _isLoading = duty;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
  }
}

class PaymentCheckboxNotifier extends ChangeNotifier {
  bool _isChecked = false;
  bool get isChecked => _isChecked;
  set isChecked(bool isChecked) {
    _isChecked = isChecked;
    notifyListeners();
  }

  void reset() {
    _isChecked = false;
  }
}

class PickupLoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool duty) {
    _isLoading = duty;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
  }
}

class LoginLoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool duty) {
    _isLoading = duty;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
  }
}

class ReturnScreenLoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool duty) {
    _isLoading = duty;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
  }
}
