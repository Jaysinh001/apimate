import 'package:flutter/material.dart';

import '../theme/color/colors.dart';
import 'my_text.dart';

class MyTextfield extends StatelessWidget {
  final String hint;
  final String? label;
  final TextEditingController controller;
  final bool isEnabled;
  final bool isMultiline;
  final bool? unfocusOnTapOutside;
  final TextCapitalization? textCapitalization;
  final Widget? suffix;
  final Widget? prefix;
  final bool isObscure;
  final TextInputType? keyboardType;
  final bool shouldValidate;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmit;
  final ValueChanged<String?>? onSaved;
  final FormFieldValidator<String>? validator;

  const MyTextfield({
    super.key,
    required this.hint,
    required this.controller,
    this.isEnabled = true,
    this.isMultiline = false,
    this.isObscure = false,
    this.shouldValidate = true,
    this.validator,
    this.suffix,
    this.prefix,
    this.onChanged,
    this.onFieldSubmit,
    this.onSaved,
    this.keyboardType,
    this.label,
    this.unfocusOnTapOutside,
    this.textCapitalization,
  });

  String? defaultValidation(String? value) {
    // Prevent script and SQL injection by disallowing certain characters
    final disallowedCharacters = RegExp(
      '[<>"\'%;()&+]',
    ); // Characters commonly used in injections

    if (value!.isEmpty) {
      return 'Please enter value';
    } else if (disallowedCharacters.hasMatch(value)) {
      return 'Password contains invalid special characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: label != null ? true : false,
          child: MyText.bodyMedium(
            label ?? "",
            fontWeightType: FontWeightType.semiBold,
            style: const TextStyle(
              // color: AppColors.neutral100,
            ),
          ),
        ),
        Visibility(
          visible: label != null ? true : false,
          child: const SizedBox(height: 4),
        ),
        TextFormField(
          controller: controller,
          enabled: isEnabled,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          obscureText: isObscure,
          obscuringCharacter: "*",
          maxLines: isMultiline ? 4 : 1,
          minLines: 1,
          style: const TextStyle(
            // color: AppColors.neutral100,
            fontWeight: FontWeight.w500,
            fontSize: 14,
            height: 20 / 14,
          ),
          validator: (value) {
            if (shouldValidate && defaultValidation(value) != null) {
              return defaultValidation(
                value,
              ); // Return default validation error if applicable
            } else {
              return validator?.call(
                value,
              ); // Call custom validator if default validation passes
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onTapOutside:
              (event) =>
                  unfocusOnTapOutside == false
                      ? null
                      : FocusManager.instance.primaryFocus?.unfocus(),
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmit,
          onSaved: onSaved,
          keyboardType: keyboardType ?? TextInputType.text,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              // color: AppColors.neutral60,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              height: 20 / 14,
            ),
            suffixIcon: suffix,
            prefixIcon: prefix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                // color: AppColors.neutral30,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                // color: AppColors.neutral40,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                // color: AppColors.neutral40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
