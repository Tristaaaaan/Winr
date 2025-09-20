import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:winr/common/components/ad/interstital_ad.dart';
import 'package:winr/common/components/buttons/loading_state_notifier.dart';
import 'package:winr/common/components/buttons/regular_button.dart';
import 'package:winr/common/components/snackbar/information_snackbar.dart';
import 'package:winr/common/components/textfield/form_textfield.dart';
import 'package:winr/common/utils/winrate_input_formatter.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/core/appmodels/winrate_records.dart';
import 'package:winr/feature/history/presentation/providers/history_controller.dart';
import 'package:winr/feature/history/presentation/providers/result_provider.dart';
import 'package:winr/feature/records/presentation/providers/record_providers.dart';

import '../../../../common/utils/name_formatter.dart';

class RecordForm extends ConsumerWidget {
  final bool isUpdate;
  final WinRateRecords? recordData;
  const RecordForm({super.key, required this.isUpdate, this.recordData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(uploadImagePathProvider);
    final isRemoved = ref.watch(isImageRemovedProvider);

    final showPlaceholder =
        selectedImages.isEmpty &&
        (recordData?.backgroundImage == null ||
            recordData?.backgroundImage?.isEmpty == true ||
            isRemoved);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        showPlaceholder
            ? SizedBox(
              height: 200,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  final imagePicker = ImagePicker();
                  final XFile? pickedImage = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (pickedImage == null) {
                    if (context.mounted) {
                      informationSnackBar(
                        context,
                        Icons.info_outline,
                        "No image has been selected.",
                      );
                    }
                    return;
                  }

                  final newFile = File(pickedImage.path);
                  ref.read(uploadImagePathProvider.notifier).state = [newFile];
                  ref.read(uploadImagePathNameProvider.notifier).state = [
                    pickedImage.path,
                  ];
                  ref.read(uploadImageNameProvider.notifier).state = [
                    pickedImage.name,
                  ];
                  ref.read(isImageRemovedProvider.notifier).state = false;
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        height: 100,
                        width: 100,
                        AppImages.uploadImage,
                      ),
                      const SizedBox(height: 25),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_upload_outlined),
                          SizedBox(width: 10),
                          Text("Add Image (optional)"),
                        ],
                      ),
                      const Text(
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                        "You can only select 1 image.",
                      ),
                    ],
                  ),
                ),
              ),
            )
            : SizedBox(
              height: 200,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Builder(
                      builder: (context) {
                        if (selectedImages.isNotEmpty) {
                          return Image.file(
                            selectedImages.first,
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                          );
                        }

                        if (!isRemoved &&
                            recordData?.backgroundImage != null &&
                            recordData!.backgroundImage!.isNotEmpty) {
                          return Image.memory(
                            base64Decode(recordData!.backgroundImage!),
                            height: double.infinity,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        onTap: () {
                          ref.read(uploadImagePathProvider.notifier).state = [];
                          ref.read(uploadImagePathNameProvider.notifier).state =
                              [];
                          ref.read(uploadImageNameProvider.notifier).state = [];
                          ref.read(isImageRemovedProvider.notifier).state =
                              true;
                        },
                        child: const Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        const SizedBox(height: 20),
        FormTextField(
          fieldKey: 'name',
          labelText: 'How about adding a name? (optional)',
          inputFormatters: const [MaxLengthFormatter()],
          isUpdate: true,
          initialValue: recordData?.name,
          onChanged: (value) => ref.read(nameProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),
        FormTextField(
          fieldKey: 'numberOfBattles',
          labelText: 'What is your current number of battles?',
          inputFormatters: const [
            WinrateInputFormatter(integersOnly: true, max: double.infinity),
          ],
          isUpdate: isUpdate,
          initialValue: recordData?.currentNumberOfBattles.toString(),
          onChanged:
              (value) =>
                  ref.read(numberOfBattlesProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),
        FormTextField(
          fieldKey: 'winRate',
          showPercentSuffix: true,
          labelText: 'What is your current win rate? (in Percentage)',
          inputFormatters: const [
            WinrateInputFormatter(integersOnly: false, max: 100),
          ],
          isUpdate: isUpdate,
          initialValue: recordData?.currentWinRate.toString(),
          onChanged:
              (value) => ref.read(winRateProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),
        FormTextField(
          fieldKey: 'desiredWinRate',
          showPercentSuffix: true,
          labelText: 'What is your desired win rate? (in Percentage)',
          inputFormatters: const [
            WinrateInputFormatter(integersOnly: false, max: 100),
          ],
          isUpdate: isUpdate,
          initialValue: recordData?.desiredWinRate.toString(),
          onChanged:
              (value) =>
                  ref.read(desiredWinRateProvider.notifier).state = value,
        ),
        const SizedBox(height: 50),
        if (ref.watch(requiredWinsMessageProvider) != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.2,
              ),
            ),
            child: Text(
              ref.watch(requiredWinsMessageProvider) ?? "",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        const SizedBox(height: 20),
        Row(
          children: [
            if (isUpdate) ...[
              IconButton(
                icon: const Icon(Icons.delete_forever_outlined),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () async {
                  if (!context.mounted) return;

                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: const Text("Record Deletion"),
                        content: const Text(
                          "Are you sure you want to delete this record? This action cannot be undone.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm != true) return;

                  final isLoading = ref.read(
                    regularButtonLoadingProvider.notifier,
                  );
                  isLoading.setLoading("deleteButton", true);

                  try {
                    await ref
                        .read(historyControllerProvider.notifier)
                        .deleteRecord(recordData!.id!);

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    informationSnackBar(
                      context,
                      Icons.delete_outline,
                      "Record has been deleted!",
                    );
                  } finally {
                    ref.invalidate(requiredWinsProvider);
                    ref.invalidate(desiredWinRateProvider);
                    ref.invalidate(numberOfBattlesProvider);
                    ref.invalidate(winRateProvider);
                    isLoading.setLoading("deleteButton", false);
                  }
                },
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: RegularButton(
                suffixIcon: false,
                withIcon: false,
                text: "Save",
                onTap: () async {
                  final isLoading = ref.read(
                    regularButtonLoadingProvider.notifier,
                  );
                  isLoading.setLoading("saveButton", true);

                  try {
                    await ref
                        .read(saveRecordUseCaseProvider)
                        .call(
                          isUpdate: isUpdate,
                          recordData: recordData,
                          selectedImages: selectedImages,
                        );

                    if (!context.mounted) return;
                    Navigator.pop(context);
                    informationSnackBar(
                      context,
                      Icons.check_circle_outline_outlined,
                      "Record has been saved!",
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    informationSnackBar(
                      context,
                      Icons.error_outline,
                      e.toString(),
                    );
                  } finally {
                    isLoading.setLoading("saveButton", false);
                    InterstitialAdManager().maybeShowInterstitial();
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).colorScheme.surface,
                buttonKey: "saveButton",
                width: double.infinity,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
