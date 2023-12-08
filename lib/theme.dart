import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverThemeDarkModel extends StateNotifier<bool> {
  RiverThemeDarkModel() : super(false) {}

  bool get isDark {
    print("model asked for dark status: ${state}");
    return state;
  }

  toggleDark() {
    print("toggler has listeners: ${hasListeners}");
    state = !state;
    print("toggled to: ${state}");
  }
  
  set isDark(bool value) {
    state = value;
  }
}