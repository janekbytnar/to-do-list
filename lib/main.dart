import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:soft_for/app.dart';
import 'package:user_repository/user_repository.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp(
    FirebaseUserRepo(),
  ));
}
