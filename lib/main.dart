import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/screens/cart_screen.dart';
import 'package:untitled6/screens/edit_profile_screen.dart';
import 'package:untitled6/screens/membership_screen.dart';

import 'layout/LayoutScreen.dart';
import 'layout/cubit/cubit.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Omni Link',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Sleek, modern blue
          brightness: Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => ProjectCubit(),
        child: const ProjectLayout(),
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/cart': (context) => CartScreen(),
        '/membership': (context) => MembershipScreen(),
      },
    );
  }
}
