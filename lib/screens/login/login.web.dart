import 'package:ebutler/providers/user.provider.dart';
import 'package:ebutler/utils/constants.dart';
import 'package:ebutler/widgets/alert.dart';
import 'package:ebutler/widgets/async_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class LoginWeb extends StatefulWidget {
  const LoginWeb({super.key});

  @override
  State<LoginWeb> createState() => _LoginWebState();
}

class _LoginWebState extends State<LoginWeb> {
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
      body: ListView(
        padding: const EdgeInsets.all(
          50,
        ),
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(radius),
              clipBehavior: Clip.hardEdge,
              child: Container(
                height: 700,
                width: 800,
                padding: const EdgeInsets.all(50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              bottom: 40,
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email cannot be empty';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: 'Email',
                                prefixIcon: HeroIcon(
                                  HeroIcons.envelope,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: TextFormField(
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password cannot be empty';
                                }
                                if (value.length < 8) {
                                  return 'Password needs to be at least 8 characters long';
                                }
                                return null;
                              },
                              obscureText: _isPasswordHidden,
                              decoration: InputDecoration(
                                hintText: 'Password',
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Forgot password ?',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: AsyncButton(
                              text: 'Login',
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await Provider.of<UserProvider>(
                                      context,
                                      listen: false,
                                    ).loginWithEmail(
                                      _emailController.text.trim(),
                                      _passwordController.text,
                                    );
                                    if (!mounted) return;
                                    context.go('/chat');
                                  } catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Alert(
                                        title: 'Error logging in',
                                        content: '$e',
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
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
                                              decoration:
                                                  TextDecoration.underline,
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
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
