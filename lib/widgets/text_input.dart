import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../imports.dart';

class TextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? name;
  final String? label;
  final String? initialValue;
  final IconData? icon;
  final bool? obscureText;
  final bool enabled;
  final FormFieldValidator<String>? validator;

  const TextInput(
      {Key? key,
      this.controller,
      this.name,
      this.label,
      this.initialValue,
      this.icon,
      this.enabled = true,
      this.obscureText,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: FormBuilderTextField(
        style: TextStyle(color: Get.theme.colorScheme.onBackground),
        controller: controller,
        name: name!,
        initialValue: initialValue,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: enabled
                  ? Get.theme.colorScheme.onBackground
                  : Get.theme.disabledColor),
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Get.theme.colorScheme.secondary),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Get.theme.colorScheme.onBackground),
          ),
          border: const OutlineInputBorder(borderSide: BorderSide()),
        ),
        validator: validator,
        obscureText: obscureText!,
      ),
    );
  }
}
