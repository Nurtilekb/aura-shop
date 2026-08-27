import 'package:aurashop/core/routing/app_router.gr.dart';
import 'package:aurashop/bloc/auth/auth_bloc.dart';
import 'package:aurashop/bloc/auth/auth_event.dart';
import 'package:aurashop/bloc/auth/auth_state.dart';
import 'package:aurashop/shared/widgets/custom_widgets/iconwith_background_widget.dart';
import 'package:auto_route/auto_route.dart';
import 'package:aurashop/shared/widgets/app_input_widget.dart';
import 'package:aurashop/shared/widgets/custom_widgets/pressed_button.dart';
import 'package:flutter/material.dart';
import 'package:aurashop/core/utils/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthAuthenticated) {
          final isAdmin = authState.user.isAdmin;
          context.router.replaceAll([
            isAdmin ? const Main2Route() : const MainRoute(),
          ]);
        } else if (authState is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(authState.message)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
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
                          IconWithBack(
                            emoji: 'A',
                            color: Colors.white,
                            emojiSizes: 50,
                            fontwght: FontWeight(800),
                          ),

                          SizedBox(height: 40),
                          Text(
                            "С возвращением!",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight(700),
                            ),
                          ),
                          Text(
                            "Войдите, чтобы продолжить покупки",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 20),
                          AppInputWidget(
                            validator: Validators.validateEmail,

                            labelStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                              fontWeight: FontWeight(400),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            filledColor: Colors.transparent,
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
                            filledColor: Colors.transparent,
                            controller: _passwordController,
                            label: 'Пароль',

                            hintText: "Напишите ваш пароль",
                            isPasswordField: true,
                            validator: Validators.validatePassword,
                          ),
                          const SizedBox(height: 40), //////
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, authState) {
                              return PressedButton(
                                height: 56,
                                onPressed: authState is AuthLoading
                                    ? null
                                    : _handleLogin,
                                text: 'Войти',

                                textstyle: null,
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(
                                child: Divider(height: 1, color: Colors.grey),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
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
                            backgroundColor: Colors.white,
                            onPressed: () => context.read<AuthBloc>().add(
                              AuthGoogleRequested(),
                            ),
                            imagePath: "assets/icons/google.png",
                            borderColor: Colors.grey,
                            padding: const EdgeInsets.only(top: 1),
                            text: 'Войти через Google',

                            height: 56,
                            textstyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            borderradius: null,
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Нет аккаунта? ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
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
                if (isLoading)
                  Positioned.fill(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: 1,
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                  ),
              ],
            );
          },
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
          color: Theme.of(context).primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim().toLowerCase(),
          password: _passwordController.text,
        ),
      );
    }
  }
}
