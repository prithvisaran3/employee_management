import 'package:flutter/material.dart';

import '../../themes/colors.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField(
      {Key? key,
      required this.hintText,
      required this.controller,
      this.validator,
      this.obscureText,
      this.maxLength,
      this.errorText,
      this.prefixIcon,
      this.enableBorderSide = false,
      this.keyboardtype})
      : super(key: key);
  final String hintText;
  final String? errorText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool? obscureText;
  final bool? enableBorderSide;
  final int? maxLength;
  final IconData? prefixIcon;
  final TextInputType? keyboardtype;

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
        ),
        child: TextFormField(
          keyboardType: widget.keyboardtype,
          style: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
          ),
          validator: widget.validator,
          cursorColor: AppColors.primary,
          controller: widget.controller,
          maxLength: widget.maxLength,
          maxLines: 1,
          obscuringCharacter: "*",
          obscureText: widget.obscureText == true ? !passwordVisible : false,
          decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              hintText: widget.hintText,
              errorText: widget.errorText,
              hintStyle: const TextStyle(fontFamily: "Poppins"),
              counterText: "",
              contentPadding: const EdgeInsets.only(left: 5),
              border: OutlineInputBorder(
                borderSide: widget.enableBorderSide == true
                    ? BorderSide(
                        color: AppColors.primary.withOpacity(.2),
                      )
                    : BorderSide.none,
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.primary.withOpacity(.5), width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.red, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: showPassword(),
              prefixIcon: Icon(widget.prefixIcon)),
        ),
      ),
    );
  }

  bool passwordVisible = false;

  Widget showPassword() {
    if (widget.obscureText == true) {
      return ButtonTheme(
          child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0),
        ),
        onPressed: () {
          setState(() {
            passwordVisible = !passwordVisible;
          });
        },
        child: Icon(
          passwordVisible == true ? Icons.visibility : Icons.visibility_off,
          color: AppColors.grey.withOpacity(.3),
        ),
      ));
    } else {
      return const SizedBox.shrink();
    }
  }
}
