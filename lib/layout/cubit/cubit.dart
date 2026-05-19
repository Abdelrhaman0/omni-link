
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/screens/categories_screen.dart';
import 'package:untitled6/screens/main_screen.dart';
import 'package:untitled6/screens/products_screen.dart';
import 'package:untitled6/screens/profile_screen.dart';

import 'cubit-states.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(ProjectInitialState());

  static ProjectCubit get(BuildContext context) => BlocProvider.of<ProjectCubit>(context);


  int currentIndex = 0;

  List<Widget> screens = [
    MainScreen(),
    CategoriesScreen(),
    ProductsScreen(),
    ProfileScreen(),
  ];

  List<String> title = ['Main', 'Categories', 'Products', 'Profile'];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ProjectChangeBottomNavState());
  }
}