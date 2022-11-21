import 'package:getx/src/constants/endpoints.dart';
import 'package:getx/src/models/user_model.dart';
import 'package:getx/src/pages/auth/repository/auth_errors.dart' as auth_errors;
import 'package:getx/src/pages/auth/result/auth_result.dart';
import 'package:getx/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  // Função interna pra tratar usuário ou erro
  AuthResult _handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);
      return AuthResult.success(user);
    } else {
      return AuthResult.error(auth_errors.authErrorsString(result['error']));
    }
  }

  // Logar
  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    final result = await _httpManager
        .restRequest(url: Endpoints.signIn, method: HttpMethods.post, body: {
      "email": email,
      "password": password,
    });

    return _handleUserOrError(result);
  }

  // Validar token
  Future<AuthResult> validateToken(String token) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.validateToken,
      method: HttpMethods.post,
      headers: {'X-Parse-Session-Token': token},
    );
    return _handleUserOrError(result);
  }

  // Cadastrar
  Future<AuthResult> signUp(UserModel user) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.signUp,
      method: HttpMethods.post,
      body: user.toJson(),
    );

    return _handleUserOrError(result);
  }

  // Resetar senha
  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
        url: Endpoints.resetPassword,
        method: HttpMethods.post,
        body: {'email': email});
  }

  // Mudar senha
  Future<bool> changePassword({
    required String token,
    required email,
    required currentPassword,
    required newPassword,
  }) async {
    final result = await _httpManager.restRequest(
      url: Endpoints.changePassword,
      method: HttpMethods.post,
      headers: {'X-Parse-Session-Token': token},
      body: {
        'email': email,
        'currentPassword': currentPassword,
        'newPassword': newPassword
      },
    );
    return result['error'] == null;
  }
}
