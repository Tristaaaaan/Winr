import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final lastPageProvider = StateProvider.autoDispose<bool>((ref) => false);
final currentPageProvider = StateProvider<int>((ref) => 0);
final isGetStartedLoadingProvider = StateProvider<bool>((ref) => false);
final firstTimeCheckProvider = StreamProvider.autoDispose<bool>((ref) async* {
  final prefs = await SharedPreferences.getInstance();
  bool currentValue = prefs.getBool('isFirstTime') ?? true;
  yield currentValue;

  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    final newValue = prefs.getBool('isFirstTime') ?? true;

    if (newValue != currentValue) {
      currentValue = newValue;
      yield currentValue;
    }
  }
});
