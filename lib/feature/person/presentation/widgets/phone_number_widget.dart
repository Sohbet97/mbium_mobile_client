import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

class PhoneNumberWidget extends StatelessWidget {
  final PhoneController controller;
  final String? Function(PhoneNumber?)? validator;
  final String hintText;
  const PhoneNumberWidget({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return PhoneFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade500,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff706D6D)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
      ),

      countrySelectorNavigator: const CountrySelectorNavigator.dialog(),

      isCountrySelectionEnabled: true,

      countryButtonStyle: const CountryButtonStyle(
        showDialCode: true,
        showIsoCode: false,
        showFlag: true,
      ),

      validator: validator,
    );
  }
}
