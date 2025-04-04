import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/auth/presentation/widgets/auth_gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/show_snackbar.dart';
import '../../../blog/presentation/pages/blog_page.dart';
import '../widgets/auth_field.dart';
import 'login_page.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const SignupPage(),
      );

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    formKey.currentState?.validate();
    return Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    if(state is AuthFailure){
      showSnackBar(context, state.message);
    }
    else if (state is AuthSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        BlogPage.route(),
            (route) => false,
      );
    }
  },
  builder: (context, state) {
    if(state is AuthLoading){
      return const Loader();
    }
    return Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                AuthField(
                  hintText: 'Name',
                  controller: nameController,
                ),
                const SizedBox(height: 15),
                AuthField(
                  hintText: 'Email',
                  controller: emailController,
                ),
                const SizedBox(height: 15),
                AuthField(
                  hintText: 'Password',
                  controller: passwordController,
                  isObscureText: true,
                ),
                const SizedBox(height: 20),
                AuthGradientButton(
                    buttonText: "Sign Up",
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        // BlocProvider.of<AuthBloc>(context).add(AuthSignUp(
                        //   name: nameController.text,
                        //   email: emailController.text,
                        //   password: passwordController.text,
                        // ));
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              ),
                            );
                      }
                    }),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      LoginPage.route(),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                        text: 'Already have an account? ',
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          );
  },
),
        ));
  }
}
