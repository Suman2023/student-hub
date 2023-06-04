import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/services/feeds_service.dart';

import '../models/feeds_timeline_model.dart';

final postHeartedStateProvider = StateProvider<bool>((ref) => false);

final pickedFileStateProvider = StateProvider<File?>((ref) => null);

final feedServiceProvider = Provider<FeedService>((ref) => FeedService());

final postInProgressStateProvider = StateProvider<bool>((ref) => false);

final timelineFeedsProvider = FutureProvider<List<FeedsTimeline>>((ref) async {
  final feedservice = ref.read(feedServiceProvider);
  return await feedservice.getMyTimeline();
});
