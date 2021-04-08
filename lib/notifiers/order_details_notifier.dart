import 'package:flutter/material.dart';

class OrderDetailsLoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    if (isLoading != _isLoading) {
      _isLoading = isLoading;
      notifyListeners();
    }
  }

  void setLoading(bool isLoading) {
    _isLoading = isLoading;
  }

  void reset() {
    _isLoading = false;
  }
}

class OrderTimelineNotifier extends ChangeNotifier {
  void responseReceived() {
    notifyListeners();
  }
}
