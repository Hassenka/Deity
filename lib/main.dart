import 'package:diety/app.dart';
import 'package:diety/logic/bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => DietyApp()),
  );
}
