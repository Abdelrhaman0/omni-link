import '../../../../core/network/dio_helper.dart';
import '../../../../core/network/endpoints.dart';
import '../models/login_model.dart';
import '../models/register_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
  });

  Future<RegisterModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<LoginModel> login({
    required String email,
    required String password,
  }) async {
    final response = await DioHelper.postData(
      url: loginEndpoint,
      data: {
        'email': email,
        'password': password,
      },
    );
    return LoginModel.fromJson(response.data);
  }

  @override
  Future<RegisterModel> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final response = await DioHelper.postData(
      url: registerEndpoint,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      },
    );
    return RegisterModel.fromJson(response.data);
  }
}
