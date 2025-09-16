import 'package:flutter_riverpod/flutter_riverpod.dart';

final regularButtonLoadingProvider =
    StateNotifierProvider<RegularButtonLoadingNotifier, Map<String, bool>>(
  (ref) => RegularButtonLoadingNotifier(),
);

class RegularButtonLoadingNotifier extends StateNotifier<Map<String, bool>> {
  RegularButtonLoadingNotifier() : super({});

  void setLoading(String buttonKey, bool isLoading) {
    state = {...state, buttonKey: isLoading};
  }
}
