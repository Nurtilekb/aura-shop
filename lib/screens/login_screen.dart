import 'package:auto_route/auto_route.dart';
import 'package:aurashop/screens/registrarion_screen.dart';
import 'package:aurashop/screens/settings_screen.dart';
import 'package:aurashop/widgets/app_input_widget.dart';
import 'package:aurashop/widgets/pressed_button.dart';
import 'package:flutter/material.dart';
import 'package:aurashop/utils/validators.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () => context.router.push(const SettingsRoute()),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            24,
            20,
            24,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Image.asset('assets/icons/icon_A_.png', width: 80, height: 80),
                SizedBox(height: 40),
                Text(
                  "С возвращением!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight(700)),
                ),
                Text(
                  "Войдите, чтобы продолжить покупки",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                AppInputWidget(
                  validator: Validators.validatePassword,

                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight(400),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  filledColor: Colors.white,
                  controller: _emailController,
                  label: 'Email',
                  hintText: 'your@gmail.com',
                  inputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                AppInputWidget(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight(400),
                  ),
                  filledColor: Colors.white,
                  controller: _passwordController,
                  label: 'Пароль',

                  hintText: "Напишите ваш пароль",
                  isPasswordField: true,
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 40),
                PressedButton(
                  onPressed: _handleLogin,
                  text: 'Войти',
                  height: 30,
                  backgroundColor: Color(0xff5D50FE),
                  textstyle: null,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(height: 1, color: Colors.grey),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Text(
                        'or',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const Expanded(
                      child: Divider(height: 1, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PressedButton(
                  imagePath: "assets/icons/google.png",
                  borderColor: Colors.black,
                  padding: EdgeInsets.only(top: 1),
                  text: 'Регистрация через Google',
                  backgroundColor: Color(0xff5D50FE),
                  height: 56,
                  textstyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  borderradius: null,
                ),

                // InkWell(
                //   onTap: () {},
                //   borderRadius: BorderRadius.circular(12),
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(
                //       horizontal: 24,
                //       vertical: 10,
                //     ),
                //     width: double.infinity,
                //     height: 56,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(12),
                //   border: Border.all(color: Colors.grey.shade300, width: 1),
                // ),
                //     child: const Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                //         SizedBox(width: 20),
                //         Text(
                //           'Sign in with Google',
                //           style: TextStyle(
                //             fontSize: 16,
                //             fontWeight: FontWeight.w600,
                //             color: Colors.black,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Нет аккаунта? ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 18,
                        fontWeight: FontWeight(300),
                      ),
                    ),
                    _forLogin(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _forLogin() {
    return GestureDetector(
      onTap: () {
        context.router.push(const RegistrationRoute());
      },
      child: Text(
        'Зарегистрироваться',
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      print('Email: $email, Password: $password');
    }
  }
}
