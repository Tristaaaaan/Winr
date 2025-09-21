import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winr/common/utils/convert_images.dart';
import 'package:winr/core/appmodels/winrate_records.dart';
import 'package:winr/feature/history/presentation/providers/result_provider.dart';
import 'package:winr/feature/records/domain/record_repo.dart';
import 'package:winr/feature/records/presentation/providers/record_providers.dart';

class SaveRecordUseCase {
  final RecordRepository repository;
  final Ref ref;

  SaveRecordUseCase(this.repository, this.ref);

  Future<void> call({
    required bool isUpdate,
    WinRateRecords? recordData,
    required List<File> selectedImages,
  }) async {
    // Build record
    final record = WinRateRecords(
      id: recordData?.id,
      backgroundImage: await _getBackgroundImage(
        ref,
        selectedImages,
        recordData,
      ),
      name: ref.read(nameProvider) ?? "",
      timeAdded:
          isUpdate
              ? recordData!.timeAdded
              : DateTime.now().microsecondsSinceEpoch,
      lastUpdated: isUpdate ? DateTime.now().millisecondsSinceEpoch : 0,
      desiredWinRate: double.tryParse(ref.read(desiredWinRateProvider)) ?? 0,
      currentNumberOfBattles:
          int.tryParse(ref.read(numberOfBattlesProvider)) ?? 0,
      currentWinRate: double.tryParse(ref.read(winRateProvider)) ?? 0,
    );

    // Save via repository
    await repository.saveRecord(record, isUpdate: isUpdate);

    // Clear form state
    ref.invalidate(requiredWinsProvider);
    ref.invalidate(desiredWinRateProvider);
    ref.invalidate(numberOfBattlesProvider);
    ref.invalidate(winRateProvider);
  }

  Future<String?> _getBackgroundImage(
    Ref ref,
    List<File> selectedImages,
    WinRateRecords? recordData,
  ) async {
    final isRemoved = ref.read(isImageRemovedProvider);
    if (selectedImages.isNotEmpty) {
      final converter = ConvertImages();
      return await converter.encodeImageToBase64(selectedImages.first);
    } else if (isRemoved) {
      return null;
    } else {
      return recordData?.backgroundImage;
    }
  }
}
