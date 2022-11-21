import 'package:get/get.dart';
import 'package:getx/src/constants/storage_keys.dart';
import 'package:getx/src/models/user_model.dart';
import 'package:getx/src/pages/auth/repository/auth_repository.dart';
import 'package:getx/src/pages/auth/result/auth_result.dart';
import 'package:getx/src/pages_routes/app_pages.dart';
import 'package:getx/src/services/util_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final authRepository = AuthRepository();
  final utilServices = UtilsServices();

  UserModel user = UserModel();

  // Salvar token e ir pra home
  void saveTokenAndProceedToBase() {
    // Salvar o token
    utilServices.saveLocalData(key: StorageKeys.token, data: user.token!);

    // Ir para base
    Get.offAllNamed(PagesRoute.baseRoute);
  }

  // Validar token
  Future<void> validateToken() async {
    // Recuperar token localmente
    String? token = await utilServices.getLocalData(key: StorageKeys.token);

    if (token == null) {
      Get.offAllNamed(PagesRoute.signInRoute);
      return;
    }

    AuthResult result = await authRepository.validateToken(token);

    result.when(success: (user) {
      this.user = user;
      saveTokenAndProceedToBase();
    }, error: (message) {
      signOut();
    });
  }

  // Deslogar
  Future<void> signOut() async {
    // Zerar o user
    user = UserModel();
    // Remover o token localmente
    await utilServices.removeLocalData(key: StorageKeys.token);
    // Ir para o login
    Get.offAllNamed(PagesRoute.signInRoute);
  }

  // Logar
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    AuthResult result =
        await authRepository.signIn(email: email, password: password);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;

        // Salvar token localmente
        saveTokenAndProceedToBase();
      },
      error: (message) {
        utilServices.showToast(message: message, isError: true);
      },
    );
  }

  // Cadastrar
  Future<void> signUp() async {
    isLoading.value = true;

    AuthResult result = await authRepository.signUp(user);

    isLoading.value = false;

    result.when(
      success: (user) {
        this.user = user;

        // Salvar token localmente
        saveTokenAndProceedToBase();
      },
      error: (message) {
        utilServices.showToast(message: message, isError: true);
      },
    );
  }

  // Resetar senha
  Future<void> resetPassword(String email) async {
    await authRepository.resetPassword(email);
  }

  // Mudar senha
  Future<void> changePassword(
      {required String currentPassword, required String newPassword}) async {
    isLoading.value = true;
    final result = await authRepository.changePassword(
        token: user.token!,
        email: user.email!,
        currentPassword: currentPassword,
        newPassword: newPassword);
    isLoading.value = false;
    if (result) {
      utilServices.showToast(
        message: 'A senha foi atualizada com sucesso',
      );
      signOut();
    } else {
      utilServices.showToast(
          message: 'A senha atual está incorreta', isError: true);
    }
  }
}
