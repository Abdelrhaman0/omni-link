import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../component/conests.dart';
import '../screens/search_screen.dart';
import 'cubit/cubit-states.dart';
import 'cubit/cubit.dart';


class ProjectLayout extends StatelessWidget {
  static String id = 'ProjectLayout';

  const ProjectLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {

      },
      builder: (context, state) {
        var cubit = ProjectCubit.get(context);
        return Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  snap: true,
                  expandedHeight: 56.0,
                  // Set the height you want for the app bar
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            cubit.title[cubit.currentIndex],
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),),
                        ]

                    ),
                    titlePadding: EdgeInsets.only(
                        left: 16.0, bottom: 16.0), // Adjust padding if needed
                  ),
                  actions: [
                    Row(
                      children: [
                        IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined)),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            );
                          },
                          icon: Icon(Icons.search, size: 30, color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ],
                  backgroundColor: Colors.white,
                  elevation: 5,
                  shadowColor: Colors.grey.withOpacity(0.5),
                  iconTheme: IconThemeData(color: kPrimaryColor),
                ),
              ];
            },
            body: IndexedStack(
              index: cubit.currentIndex,
              children: cubit.screens,
            ),
          ),

          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
                currentIndex: cubit.currentIndex,
                backgroundColor: Colors.white,
                selectedItemColor: kPrimaryColor,
                unselectedItemColor: Colors.grey,
                selectedFontSize: 14,
                unselectedFontSize: 12,
                elevation: 20,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Main',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.category_outlined),
                    label: 'Categories',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.devices),
                    label: 'Products',
                  ),

                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_rounded),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}


