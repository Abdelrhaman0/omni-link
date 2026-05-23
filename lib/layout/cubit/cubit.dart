
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled6/features/cart/cart_screen.dart';
import '../../features/categories/categories_screen.dart';
import '../../features/home/main_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/profile/profile_screen.dart';
import 'cubit-states.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(ProjectInitialState());

  static ProjectCubit get(BuildContext context) => BlocProvider.of<ProjectCubit>(context);


  int currentIndex = 0;

  List<Widget> screens = [
    MainScreen(),
    CategoriesScreen(),
    ProductsScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  List<String> title = ['Omni-Link', 'Categories', 'Products', 'Cart', 'Profile'];

  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ProjectChangeBottomNavState());
  }
}