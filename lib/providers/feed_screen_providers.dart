import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/services/feeds_service.dart';

final postHeartedStateProvider = StateProvider<bool>((ref) => false);

final pickedFileStateProvider = StateProvider<File?>((ref) => null);

final feedServiceProvider = Provider<FeedService>((ref) => FeedService());

final postInProgressStateProvider = StateProvider<bool>((ref)=>false);
