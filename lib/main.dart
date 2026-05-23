import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/network/dio_helper.dart';
import 'core/utils/cache_helper.dart';
import 'features/auth/data/datasource/auth_remote_data_source.dart';
import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/manager/auth_cubit.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/membership/membership_screen.dart';
import 'features/profile/edit_profile_screen.dart';
import 'layout/LayoutScreen.dart';
import 'layout/cubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProjectCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(
            authRepository: AuthRepository(
              remoteDataSource: AuthRemoteDataSourceImpl(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Omni Link',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2563EB), // Sleek, modern blue
            brightness: Brightness.light,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const ProjectLayout(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/edit-profile': (context) => const EditProfileScreen(),
          '/cart': (context) => CartScreen(),
          '/membership': (context) => MembershipScreen(),
        },
      ),
    );
  }
}
