import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationBarIndexStateProvider = StateProvider<int>((ref) => 0);

final pageViewControllerProvider = StateProvider<PageController>(
  (ref) => PageController(
    initialPage: 0,
  ),
);
