import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/pages/auth/controller/auth_controller.dart';
import 'package:getx/src/pages/widgets/custom_text_field.dart';
import 'package:getx/src/services/validators.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do usuário'),
        actions: [
          IconButton(
              onPressed: () => authController.signOut(),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        children: [
          CustomTextField(
              icon: Icons.email,
              label: 'Email',
              initialValue: authController.user.email,
              readOnly: true),
          CustomTextField(
              icon: Icons.person,
              label: 'Nome',
              initialValue: authController.user.name,
              readOnly: true),
          CustomTextField(
              icon: Icons.phone,
              label: 'Celular',
              initialValue: authController.user.phone,
              readOnly: true,
              inputType: TextInputType.phone),
          CustomTextField(
            icon: Icons.file_copy,
            label: 'CPF',
            isSecret: true,
            readOnly: true,
            initialValue: authController.user.cpf,
          ),
          // Atualizar Senha
          SizedBox(
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                updatePassword();
              },
              child: const Text(
                'Atualizar Senha',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<bool?> updatePassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Stack(
              children: [
                // Conteudo
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Titulo
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Atualização de senha',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Senha atual
                        CustomTextField(
                          controller: currentPasswordController,
                          icon: Icons.lock,
                          label: 'Senha atual',
                          isSecret: true,
                          validator: passwordValidator,
                        ),
                        // Nova Senha
                        CustomTextField(
                          controller: newPasswordController,
                          icon: Icons.lock_open_outlined,
                          label: 'Nova senha',
                          isSecret: true,
                          validator: passwordValidator,
                        ),
                        // Nova senha 2
                        CustomTextField(
                          icon: Icons.lock_outlined,
                          label: 'Confirmar nova senha',
                          isSecret: true,
                          validator: (password) {
                            final result = passwordValidator(password);
                            if (result != null) {
                              return result;
                            } else if (password != newPasswordController.text) {
                              return 'As senhas devem ser iguais';
                            } else {
                              return null;
                            }
                          },
                        ),
                        // Confirmar Senha
                        SizedBox(
                          height: 45,
                          child: Obx(() {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                              onPressed: authController.isLoading.value
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        authController.changePassword(
                                            currentPassword:
                                                currentPasswordController.text,
                                            newPassword:
                                                newPasswordController.text);
                                      }
                                    },
                              child: authController.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                      'Atualizar senha',
                                    ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: 5,
                    right: 5,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: const Icon(Icons.close),
                    )),
              ],
            ),
          );
        });
  }
}
