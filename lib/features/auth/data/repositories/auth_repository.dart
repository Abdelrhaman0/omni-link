import '../datasource/auth_remote_data_source.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepository({required this.remoteDataSource});

  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    return await remoteDataSource.login(
      email: email,
      password: password,
    );
  }

  Future<RegisterModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    return await remoteDataSource.register(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );
  }
}
