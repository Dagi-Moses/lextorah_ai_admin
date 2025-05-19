// ignore: must_be_immutable

import 'package:flutter/material.dart';
import 'package:lextorah_chat_bot/utils/fade_animation.dart';

class CustomTextField extends StatefulWidget {
  final bool obscureText;
  final bool showSuffixIcon;
  final String label;
  final String? errorText;
  final IconData? icon;
  final FocusNode? focusNode;
  final AutovalidateMode? autovalidateMode;

  final Function(String)? onSubmitted;

  final TextEditingController? controller;
  String? Function(String?)? validator;
  CustomTextField({
    super.key,
    this.obscureText = false,
    this.errorText,
    required this.validator,
    required this.label,
    required this.icon,
    this.showSuffixIcon = false,
    required this.controller,
    this.onSubmitted,
    this.focusNode,
    this.autovalidateMode,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      delay: 1,
      child: SizedBox(
        width: 300,

        // height: 40,
        child: TextFormField(
          autovalidateMode: widget.autovalidateMode,
          controller: widget.controller,
          onFieldSubmitted: widget.onSubmitted,
          focusNode: widget.focusNode,
          validator: widget.validator,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            errorText: widget.errorText,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 0, color: Colors.transparent),
              borderRadius: BorderRadius.circular(12.0),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(width: 1, color: Colors.green),
              borderRadius: BorderRadius.circular(12.0),
            ),
            prefixIcon: Icon(widget.icon, color: Colors.black, size: 20),
            suffixIcon:
                widget.showSuffixIcon
                    ? GestureDetector(
                      onTap: _toggleVisibility,
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                    )
                    : null,
            labelText: widget.label,
            labelStyle: TextStyle(color: Colors.black, fontSize: 12),
          ),
          obscureText: _obscureText,
          textAlignVertical: TextAlignVertical.center,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
