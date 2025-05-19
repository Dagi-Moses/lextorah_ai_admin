import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lextorah_chat_bot/components/otpCard.dart';
import 'package:lextorah_chat_bot/providers/auth_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

class PinCodeVerificationScreen extends ConsumerStatefulWidget {
  final String? email;

  const PinCodeVerificationScreen({super.key, this.email});
  @override
  ConsumerState<PinCodeVerificationScreen> createState() =>
      _PinCodeVerificationScreenState();
}

class _PinCodeVerificationScreenState
    extends ConsumerState<PinCodeVerificationScreen> {
  TextEditingController textEditingController = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.watch(authProvider.notifier);
    final auth = ref.watch(authProvider);
    return OtpCard(
      errorMessage: auth.errorMessage,
      onChanged: (value) {
        //  regProvider.currentText = value;
      },
      email: widget.email,
      formKey: formKey,
      errorController: errorController,
      textEditingController: textEditingController,
      onCompleted: (v) {
        authNotifier.verifyOtp(
          context: context,
          errorController: errorController,
          email: widget.email,
          otp: v,
        );
      },

      hasError: auth.errorMessage != null,
      isLoading: auth.authLoading,
      onResend: () async {
        await authNotifier.freeTrialLogin(
          email: widget.email ?? "",
          resendController: textEditingController,
          isResend: true,
          ref: ref,
          context: context,
        );
      },
      currentText: "",
    );
  }
}
