import 'package:diety/app.dart';
import 'package:diety/logic/bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:media_kit/media_kit.dart';

void main() async {
  // It's crucial to initialize Flutter bindings before using plugins.
  WidgetsFlutterBinding.ensureInitialized();

  // Lock device orientation to portrait mode (up and down)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize media_kit for video playback.
  MediaKit.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  runApp(const DietyApp());
}
