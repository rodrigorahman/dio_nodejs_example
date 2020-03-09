import 'package:dio_nodejs_example/utils/custom_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  login() {
    var dio = CustomDio().instance;

    dio.post('http://localhost:3000/login', data: {
      'username': 'rodrigorahman',
      'password': 'rahman'
    }).then((res) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', res.data['token']);
    }).catchError((err) {
      throw Exception('Login ou senha inválidos');
    });
  }
}
