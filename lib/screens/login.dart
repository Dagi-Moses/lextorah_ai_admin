import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/components/customButton.dart';
import 'package:lextorah_chat_bot/components/customTextField.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';
import 'package:lextorah_chat_bot/src/routes.dart';
import 'package:lextorah_chat_bot/utils/fade_animation.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  final _formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isFreeTrial = false;
  void _submitForm() {
    final authNotifier = ref.watch(authProvider.notifier);
    final auth = ref.watch(authProvider);

    if (auth.authLoading) return;
    if (_formkey.currentState!.validate()) {
      if (isFreeTrial) {
        authNotifier.freeTrialLogin(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
        );
      } else {
        authNotifier.standardLogin(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Colors.white,

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5),
                const Text(
                  "Welcome to lextorah - school of languages",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center, // Ensure the text is centered
                ),
                const SizedBox(height: 5),
                const Text(
                  "Get answers to your academic questions instantly",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center, // Ensure the text is centered
                ),
                const SizedBox(height: 5),
                Card(
                  elevation: 10,
                  color: Colors.white,
                  child: Container(
                    width: 400,
                    padding: EdgeInsets.only(
                      left: 40,
                      right: 40,
                      top: 40,
                      bottom: 30,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeAnimation(
                          delay: 0.8,
                          child: Image.network(
                            "https://cdni.iconscout.com/illustration/premium/thumb/job-starting-date-2537382-2146478.png",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        SizedBox(height: 10),
                        FadeAnimation(
                          delay: 1,
                          child: const Text(
                            "Please sign in to continue",
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextField(
                                focusNode: _emailFocusNode,
                                errorText: null,
                                label: 'Email/Student ID',
                                icon: Icons.email_outlined,

                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Student ID';
                                  }
                                  return null;
                                },
                                onSubmitted: (_) {
                                  // Move to next field when "Enter" is pressed
                                  FocusScope.of(
                                    context,
                                  ).requestFocus(_passwordFocusNode);
                                },
                                controller: emailController,
                              ),
                              SizedBox(height: 20),
                              CustomTextField(
                                focusNode: _passwordFocusNode,
                                errorText: null,
                                label: 'Password',
                                icon: Icons.lock_outline,
                                obscureText: true,
                                showSuffixIcon: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Password';
                                  }
                                  return null;
                                },
                                controller: passwordController,
                                onSubmitted: (_) {
                                  _submitForm();
                                },
                              ),
                              SizedBox(height: 10),
                              FadeAnimation(
                                delay: 1,
                                child: ToggleButtons(
                                  isSelected: [!isFreeTrial, isFreeTrial],
                                  borderRadius: BorderRadius.circular(12),
                                  selectedColor: Colors.white,
                                  fillColor: Colors.green,
                                  color: Colors.black,
                                  constraints: BoxConstraints(
                                    minHeight: 30,
                                    minWidth: 40,

                                    maxHeight: 30,
                                  ),
                                  onPressed: (index) {
                                    setState(() {
                                      isFreeTrial = index == 1;
                                    });
                                  },
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 0,
                                      ),
                                      child: Text(
                                        "Standard",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Text(
                                        "Free-trial",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        auth.errorMessage != null
                            ? Center(
                              child: Text(
                                auth.errorMessage!,
                                softWrap: true,

                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.red,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            )
                            : SizedBox(),
                        const SizedBox(height: 20),
                        CustomButton(
                          buttonText: "Login",
                          onPressed: () {
                            _submitForm();
                          },
                          isLoading: auth.authLoading,
                          backgroundColor: Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),

                //End of Center Card
                //Start of outer card
                SizedBox(height: 10),
                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey[800],
                          letterSpacing: 0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go(AppRoutePath.register);
                        },
                        child: Text(
                          "free-trial Sign up",

                          style: TextStyle(
                            color: Colors.blue.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
