import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_for/lib/screens/auth/views/welcome_screen.dart';
import 'package:soft_for/lib/screens/home/views/home.dart';

import 'blocs/authentication_bloc/authentication_bloc.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Software for enterprise',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade200,
          onSurface: Colors.black,
        ),
      ),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, authState) {
          //user is authenticated
          if (authState.status == AuthenticationStatus.authenticated) {
            return HomeScreen();
          } else {
            // User is not authenticated
            return const WelcomeScreen();
          }
        },
      ),
    );
  }
}
