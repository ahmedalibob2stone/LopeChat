import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../add_information_status.dart';

class SelectStatusScreen extends ConsumerWidget {
  final File file;

  const SelectStatusScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: AddInformationStatus(file: file),
    );
  }
}
