import 'package:flutter/material.dart';

class ImageAddedNotifier extends ChangeNotifier {
  void imageAdded() {
    notifyListeners();
  }
}

class CategorySelectedNotifier extends ChangeNotifier {
  void categorySelected() {
    notifyListeners();
  }
}

class AddProductLoadingNotifier extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool isLoading) {
    if (isLoading != _isLoading) {
      _isLoading = isLoading;
      notifyListeners();
    }
  }

  void setIsLoading(bool duty) {
    _isLoading = duty;
  }

  void reset() {
    _isLoading = false;
  }
}
