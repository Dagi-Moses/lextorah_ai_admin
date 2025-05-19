import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/components/customButton.dart';
import 'package:lextorah_chat_bot/components/customTextField.dart';
import 'package:lextorah_chat_bot/controllers/register_controller.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';

import 'package:lextorah_chat_bot/src/routes.dart';
import 'package:lextorah_chat_bot/utils/fade_animation.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  RegisterController controller = RegisterController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Form(
                    key: controller.formKey,

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
                          child: Text(
                            "Create your account",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.9),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),

                        SizedBox(height: 15),
                        CustomTextField(
                          focusNode: controller.emailFocusNode,
                          errorText: null,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return "Email is Required"; // Ensures field is not empty
                            }

                            // Standard email regex validation
                            final RegExp emailRegExp = RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
                            );

                            if (!emailRegExp.hasMatch(val)) {
                              return "Please enter a valid email address"; // Ensures valid email format
                            }

                            return null;
                          },

                          controller: controller.emailController,
                          onSubmitted: (_) {
                            // Move to next field when "Enter" is pressed
                            FocusScope.of(
                              context,
                            ).requestFocus(controller.passwordFocusNode);
                          },
                        ),

                        SizedBox(height: 15),

                        CustomTextField(
                          focusNode: controller.passwordFocusNode,

                          errorText: null,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          showSuffixIcon: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Password is Required"; // Ensures field is not empty
                            }
                            if (val.length < 6) {
                              return "Password must be up to 6 characters"; // "Password must be more than six characters"
                            }
                            return null;
                          },
                          controller: controller.passwordController,
                          onSubmitted: (_) {
                            FocusScope.of(
                              context,
                            ).requestFocus(controller.confirmPasswordFocusNode);
                          },
                        ),

                        SizedBox(height: 15),

                        CustomTextField(
                          focusNode: controller.confirmPasswordFocusNode,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          errorText: null,
                          label: 'Confirm Password',
                          icon: Icons.lock_open_outlined,
                          obscureText: true,
                          showSuffixIcon: true,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Confirm Password is Required"; // Ensures field is not empty
                            }
                            if (val != controller.passwordController.text) {
                              return "Passwords do not match"; // Ensures passwords match
                            }
                            return null;
                          },
                          controller: controller.confirmPasswordController,
                          onSubmitted: (_) {
                            controller.register(context, ref);
                          },
                        ),

                        if (auth.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              auth.errorMessage!,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),

                        SizedBox(height: 25),
                        CustomButton(
                          buttonText: "Create Account",

                          isLoading: auth.authLoading,
                          onPressed: () {
                            controller.register(context, ref);
                          },
                          //  isLoading: regProvider.isLoading,
                          backgroundColor: Colors.green,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),

              //End of Center Card
              //Start of outer card
              SizedBox(height: 5),

              FadeAnimation(
                delay: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "If you have an account ",
                      style: TextStyle(color: Colors.grey, letterSpacing: 0.5),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.go(AppRoutePath.login);
                        //  GoRouter.of(context).pop();
                      },
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.blue,
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
    );
  }
}
