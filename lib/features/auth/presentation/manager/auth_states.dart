import '../../data/models/login_model.dart';
import '../../data/models/register_model.dart';

abstract class AuthStates {}

class AuthInitialState extends AuthStates {}

// Login States
class AuthLoginLoadingState extends AuthStates {}

class AuthLoginSuccessState extends AuthStates {
  final LoginModel loginModel;
  AuthLoginSuccessState(this.loginModel);
}

class AuthLoginErrorState extends AuthStates {
  final String error;
  AuthLoginErrorState(this.error);
}

// Register States
class AuthRegisterLoadingState extends AuthStates {}

class AuthRegisterSuccessState extends AuthStates {
  final RegisterModel registerModel;
  AuthRegisterSuccessState(this.registerModel);
}

class AuthRegisterErrorState extends AuthStates {
  final String error;
  AuthRegisterErrorState(this.error);
}

// Form visibility/interaction states
class AuthChangePasswordVisibilityState extends AuthStates {}
