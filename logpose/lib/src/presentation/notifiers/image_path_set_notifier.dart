// ignore_for_file: use_setters_to_change_properties

import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final imagePathSetNotifierProvider =
    StateNotifierProvider.autoDispose<_ImagePathSetNotifier, File>(
  (ref) => _ImagePathSetNotifier(),
);

class _ImagePathSetNotifier extends StateNotifier<File> {
  _ImagePathSetNotifier() : super(File(''));

  void setImagePath(File image) {
    state = image;
  }
}
