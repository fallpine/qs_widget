import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
Widget SwitchBtn({
  required bool value,
  Color? activeThumbColor,
  Color? inactiveThumbColor,
  Color? activeTrackColor,
  Color? inactiveTrackColor,
  required void Function(bool) onChanged,
}) {
  return Switch(
    value: value,
    onChanged: onChanged,
    activeThumbColor: activeThumbColor ?? Colors.white,
    inactiveThumbColor: inactiveThumbColor ?? Colors.white,
    activeTrackColor: activeTrackColor ?? Colors.green,
    inactiveTrackColor: inactiveTrackColor ?? Colors.grey,
    trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
  );
}
