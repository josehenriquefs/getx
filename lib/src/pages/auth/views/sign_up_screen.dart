import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/src/config/custom_colors.dart';
import 'package:getx/src/pages/auth/controller/auth_controller.dart';
import 'package:getx/src/services/validators.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../widgets/custom_text_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final cpfFormatter = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final phoneFormatter = MaskTextInputFormatter(
    mask: '## # ####-####',
    filter: {'#': RegExp(r'[0-9]')},
  );

  final _formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomColors.customSwatchColor,
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Stack(
            children: [
              Column(
                children: [
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Cadastro',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 40,
                      horizontal: 32,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(45),
                      ),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email
                          CustomTextField(
                            inputType: TextInputType.emailAddress,
                            icon: Icons.email,
                            label: 'Email',
                            validator: emailValidator,
                            onSaved: (newValue) {
                              authController.user.email = newValue;
                            },
                          ),
                          // Senha
                          CustomTextField(
                            icon: Icons.lock,
                            label: 'Senha',
                            isSecret: true,
                            validator: passwordValidator,
                            onSaved: (newValue) {
                              authController.user.password = newValue;
                            },
                          ), // Nome
                          CustomTextField(
                            icon: Icons.person,
                            label: 'Nome',
                            validator: nameValidator,
                            onSaved: (newValue) {
                              authController.user.name = newValue;
                            },
                          ), // Celular
                          CustomTextField(
                            inputType: TextInputType.phone,
                            inputFormatters: [phoneFormatter],
                            icon: Icons.phone,
                            validator: phoneValidator,
                            onSaved: (newValue) {
                              authController.user.phone = newValue;
                            },
                            label: 'Celular',
                          ), // CPF
                          CustomTextField(
                            inputType: TextInputType.number,
                            icon: Icons.file_copy,
                            inputFormatters: [cpfFormatter],
                            validator: cpfValidator,
                            onSaved: (newValue) {
                              authController.user.cpf = newValue;
                            },
                            label: 'CPF',
                          ), // Cadastrar
                          SizedBox(
                            height: 50,
                            child: Obx(() {
                              return ElevatedButton(
                                  onPressed: authController.isLoading.value
                                      ? null
                                      : () {
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            authController.signUp();
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18))),
                                  child: authController.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : const Text(
                                          'Cadastrar Usuário',
                                          style: TextStyle(fontSize: 15),
                                        ));
                            }),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                left: 10,
                child: SafeArea(
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
