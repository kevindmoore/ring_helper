import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_routes.dart';
import 'sounds.dart';

final routeProvider = Provider<AppRouter>((ref) {
  return AppRouter();
});

final soundProvider = Provider<SoundManager>((ref) {
  return SoundManager();
});

