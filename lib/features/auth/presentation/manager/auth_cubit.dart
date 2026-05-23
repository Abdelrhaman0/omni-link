import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(AuthInitialState());

  static AuthCubit get(BuildContext context) => BlocProvider.of<AuthCubit>(context);

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(AuthLoginLoadingState());
    authRepository.login(email: email, password: password).then((value) {
      emit(AuthLoginSuccessState(value));
    }).catchError((error) {
      emit(AuthLoginErrorState(error.toString()));
    });
  }

  void userRegister({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) {
    emit(AuthRegisterLoadingState());
    authRepository
        .register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    )
        .then((value) {
      emit(AuthRegisterSuccessState(value));
    }).catchError((error) {
      emit(AuthRegisterErrorState(error.toString()));
    });
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(AuthChangePasswordVisibilityState());
  }
}
