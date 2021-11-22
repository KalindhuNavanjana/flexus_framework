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
        controller: controller,
        name: name!,
        initialValue: initialValue,
        enabled: enabled,
        cursorColor: Util.to.isDarkMode(Get.context!)
            ? Colors.white
            : Colors.black,
        style: TextStyle(
          color : Util.to.isDarkMode(Get.context!)
              ? enabled ? Colors.white : Theme.of(context).disabledColor
              : enabled ? Colors.black : Theme.of(context).disabledColor,),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
              color: Util.to.isDarkMode(Get.context!)
                ? enabled ? Colors.white54 : Theme.of(context).disabledColor
                : enabled ? Colors.black54 : Theme.of(context).disabledColor,
          ),
          filled: true,
          fillColor: Util.to.isDarkMode(Get.context!)
            ? Colors.white12:Colors.white,
          contentPadding: const EdgeInsets.all(16),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.white),
          ),
          border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white54)),
        ),
        validator: validator,
        obscureText: obscureText!,
      ),
    );
  }
}
