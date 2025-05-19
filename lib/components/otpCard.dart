import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lextorah_chat_bot/components/customButton.dart';
import 'package:lextorah_chat_bot/src/routes.dart';
import 'package:lextorah_chat_bot/utils/fade_animation.dart';

import 'package:pin_code_fields/pin_code_fields.dart';

class OtpCard extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final bool? isRegLinkSent;
  final String? onRegLinkSent;
  final bool? isRegLinkLoading;
  final VoidCallback? onRegTap;
  final bool hasError;
  final String? email;
  final GlobalKey<FormState> formKey;
  final StreamController<ErrorAnimationType>? errorController;
  final TextEditingController textEditingController;
  final Function(String) onCompleted;
  final Function(String) onChanged;
  final VoidCallback onResend;
  final String currentText;

  const OtpCard({
    super.key,
    this.email,
    required this.formKey,
    this.errorController,
    required this.textEditingController,
    required this.onCompleted,
    required this.onChanged,
    required this.hasError,
    this.errorMessage,
    required this.isLoading,
    required this.onResend,
    required this.currentText,
    this.isRegLinkSent = false,

    this.onRegLinkSent,
    this.isRegLinkLoading,
    this.onRegTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 5,
                color: Colors.white,
                child: Container(
                  width: 400,
                  padding: const EdgeInsets.all(30.0),
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

                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "OTP Verification",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 8,
                        ),
                        child: RichText(
                          text: TextSpan(
                            text: "Enter the code sent to ",
                            children: [
                              TextSpan(
                                text: "$email",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 15,
                            ),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: formKey,

                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          obscureText: true,
                          obscuringCharacter: '*',
                          obscuringWidget: const Icon(
                            Icons.pets,
                            color: Colors.blue,
                            size: 24,
                          ),
                          blinkWhenObscuring: true,
                          animationType: AnimationType.fade,
                          validator: (value) {
                            if (value == null || value.length != 6) {
                              errorController!.add(ErrorAnimationType.shake);
                              return "Please enter a valid OTP";
                            }
                            return null;
                          },
                          pinTheme: PinTheme(
                            inactiveColor: Colors.green,
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                            inactiveFillColor: Colors.white,
                          ),
                          cursorColor: Colors.black,

                          animationDuration: const Duration(milliseconds: 300),
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Colors.black12,
                              blurRadius: 10,
                            ),
                          ],
                          onCompleted: onCompleted,
                          onChanged: onChanged,
                          beforeTextPaste: (text) {
                            return true;
                          },
                        ),
                      ),
                      (hasError || (errorMessage?.isNotEmpty ?? false))
                          ? Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                            ),
                            child: Text(
                              errorMessage ??
                                  "*Please fill up all the cells properly",
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the code? ",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          TextButton(
                            onPressed: onResend,
                            child: Text(
                              "RESEND",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      CustomButton(
                        buttonText: "Verify",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            onCompleted(currentText);
                          }
                        },
                        isLoading: isLoading,
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FadeAnimation(
                delay: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Want to try again? ",
                      style: TextStyle(color: Colors.black, letterSpacing: 0.5),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.go(AppRoutePath.login);
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
            ],
          ),
        ),
      ),
    );
  }
}
