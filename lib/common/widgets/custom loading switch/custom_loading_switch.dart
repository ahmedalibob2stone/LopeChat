import 'package:flutter/material.dart';

class CustomLoadingSwitch extends StatelessWidget {
  final bool value;
  final bool isLoading;
  final ValueChanged<bool> onChanged;

  const CustomLoadingSwitch({
    super.key,
    required this.value,
    required this.isLoading,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    )
        : Switch(
      value: value,
      onChanged: onChanged,
    );
  }
}
