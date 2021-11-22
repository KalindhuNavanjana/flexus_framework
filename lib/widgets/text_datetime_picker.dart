import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

import '../../imports.dart';

class TextDateTimePicker extends StatelessWidget {
  final String? name;
  final String? label;
  final IconData? icon;
  final DateTime? initialValue;
  final InputType? inputType;
  final bool enabled;
  final FormFieldValidator<DateTime>? validator;

  const TextDateTimePicker(
      {Key? key,
      this.name,
      this.label,
      this.icon,
      this.initialValue,
      this.inputType,
      this.enabled = true,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: FormBuilderDateTimePicker(
        name: name!,
        inputType: inputType!,
        format: DateFormat("dd/MM/yyyy"),
        style: TextStyle(
          color : Util.to.isDarkMode(Get.context!)
            ? enabled ? Colors.white : Theme.of(context).disabledColor
            : enabled ? Colors.black : Theme.of(context).disabledColor,),
        decoration: InputDecoration(
            labelStyle: TextStyle(
        color: Util.to.isDarkMode(Get.context!)
            ? enabled ? Colors.white54 : Theme.of(context).disabledColor
            : enabled ? Colors.black54 : Theme.of(context).disabledColor,
      ),
            filled: true,
            fillColor: Util.to.isDarkMode(Get.context!)
                ? Colors.white12:Colors.white,
            labelText: label,
            contentPadding: const EdgeInsets.all(16),
            border: const OutlineInputBorder(borderSide: BorderSide()),
            prefixIcon: Icon(
              icon,
              color: Util.to.isDarkMode(Get.context!)
                ? enabled ? Colors.white54 : Theme.of(context).disabledColor
                : enabled ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
            )),
        initialValue: initialValue,
        validator: validator,
        enabled: enabled,
      ),
    );
  }
}
