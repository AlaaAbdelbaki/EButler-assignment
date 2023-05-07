import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/widgets/alert.dart';
import 'package:ebutler/widgets/async_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordHidden = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      prefixIcon: HeroIcon(
                        HeroIcons.envelope,
                      ),
                      hintText: 'Email',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field cannot be empty';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      return null;
                    },
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      prefixIcon: const HeroIcon(
                        HeroIcons.lockClosed,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        }),
                        icon: HeroIcon(
                          _isPasswordHidden
                              ? HeroIcons.eye
                              : HeroIcons.eyeSlash,
                        ),
                      ),
                      hintText: 'Password',
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password ?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  child: AsyncButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final UserProvider userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        try {
                          await userProvider.loginWithEmail(
                            _emailController.text.trim(),
                            _passwordController.text,
                          );
                          if (!mounted) return;
                          context.go('/chat');
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (context) =>
                                Alert(title: 'Error', content: '$e'),
                          );
                        }
                      }
                    },
                    text: 'Login',
                  ),
                ),
                GestureDetector(
                  onTap: () => context.go('/register'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: Center(
                      child: RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Don't have an account ? ",
                            ),
                            TextSpan(
                              text: 'Register now',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
