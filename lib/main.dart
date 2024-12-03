import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_for/app.dart';
import 'package:soft_for/simple_bloc_observer.dart';
import 'package:task_repository/task_repository.dart';
import 'package:user_repository/user_repository.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(
    FirebaseUserRepo(),
    FirebaseTaskRepo(),
  ));
}
