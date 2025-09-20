import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/feature/history/presentation/providers/history_controller.dart';
import 'package:winr/feature/records/data/record_impl.dart';
import 'package:winr/feature/records/domain/record_repo.dart';
import 'package:winr/feature/records/domain/record_usecase.dart';

final uploadImagePathProvider = StateProvider<List<File>>((ref) => []);

final uploadImagePathNameProvider = StateProvider<List<String>>((ref) => []);

final uploadImageNameProvider = StateProvider<List<String>>((ref) => []);

final isImageRemovedProvider = StateProvider<bool>((ref) => false);

final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final historyController = ref.read(historyControllerProvider.notifier);
  return RecordRepositoryImpl(historyController);
});

final saveRecordUseCaseProvider = Provider<SaveRecordUseCase>((ref) {
  final repository = ref.read(recordRepositoryProvider);
  return SaveRecordUseCase(repository, ref);
});
