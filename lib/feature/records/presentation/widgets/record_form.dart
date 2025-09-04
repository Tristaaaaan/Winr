import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:winr/common/components/buttons/loading_state_notifier.dart';
import 'package:winr/common/components/buttons/regular_button.dart';
import 'package:winr/common/components/snackbar/information_snackbar.dart';
import 'package:winr/common/components/textfield/form_textfield.dart';
import 'package:winr/common/utils/convert_images.dart';
import 'package:winr/common/utils/winrate_input_formatter.dart';
import 'package:winr/core/appimages/app_images.dart';
import 'package:winr/core/appmodels/record.dart';
import 'package:winr/feature/history/data/records_database.dart';
import 'package:winr/feature/home/presentation/provider/result_provider.dart';
import 'package:winr/feature/records/presentation/providers/image_providers.dart';

import '../../../../common/utils/name_formatter.dart';

class RecordForm extends ConsumerWidget {
  final bool isUpdate;
  final WinRateRecords? recordData;
  const RecordForm({super.key, required this.isUpdate, this.recordData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages = ref.watch(uploadImagePathProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isUpdate) ...[
          (recordData?.backgroundImage == null && selectedImages.isEmpty)
              ? SizedBox(
                  height: 250,
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

                      // Update state providers (replace old one)
                      final newFile = File(pickedImage.path);
                      ref.read(uploadImagePathProvider.notifier).state = [
                        newFile,
                      ];
                      ref.read(uploadImagePathNameProvider.notifier).state = [
                        pickedImage.path,
                      ];
                      ref.read(uploadImageNameProvider.notifier).state = [
                        pickedImage.name,
                      ];

                      developer.log('Picked image path: ${pickedImage.path}');
                      developer.log('Picked image name: ${pickedImage.name}');
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
                              Text("Select Image"),
                            ],
                          ),
                          const SizedBox(height: 25),
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
                  height: 325,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: selectedImages.isNotEmpty
                            ? Image.file(
                                selectedImages.first, // 👈 provider image first
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              )
                            : Image.file(
                                File(
                                  recordData!.backgroundImage!,
                                ), // 👈 fallback
                                height: double.infinity,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: () {
                              ref.read(uploadImagePathProvider.notifier).state =
                                  [];
                              ref
                                      .read(
                                        uploadImagePathNameProvider.notifier,
                                      )
                                      .state =
                                  [];
                              ref.read(uploadImageNameProvider.notifier).state =
                                  [];
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
          FormTextField(
            fieldKey: 'name',
            labelText: 'How about adding a name?',
            inputFormatters: const [MaxLengthFormatter()],
            isUpdate: true,
            initialValue: recordData?.name,
            onChanged: (value) => ref.read(nameProvider.notifier).state = value,
          ),
        ],

        // TextField 2 → Integers only, no max limit
        FormTextField(
          fieldKey: 'numberOfBattles',
          labelText: 'What is your current number of battles?',
          inputFormatters: const [
            WinrateInputFormatter(integersOnly: true, max: double.infinity),
          ],
          isUpdate: isUpdate,
          initialValue: recordData?.currentNumberOfBattles.toString(),
          onChanged: (value) =>
              ref.read(numberOfBattlesProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),

        // TextField 3 → Decimal allowed, max 100
        FormTextField(
          fieldKey: 'winRate',
          labelText: 'What is your current win rate? (in Percentage)',
          inputFormatters: const [
            WinrateInputFormatter(integersOnly: false, max: 100),
          ],
          isUpdate: isUpdate,
          initialValue: recordData?.currentWinRate.toString(),
          onChanged: (value) =>
              ref.read(winRateProvider.notifier).state = value,
        ),
        const SizedBox(height: 12),

        // TextField 1 → Decimal allowed, max 100
        FormTextField(
          fieldKey: 'desiredWinRate',
          labelText: 'What is your desired win rate? (in Percentage)',
          inputFormatters: const [
            WinrateInputFormatter(integersOnly: false, max: 100),
          ],
          isUpdate: isUpdate,
          initialValue: recordData?.desiredWinRate.toString(),
          onChanged: (value) =>
              ref.read(desiredWinRateProvider.notifier).state = value,
        ),

        const SizedBox(height: 50),

        // Dynamic text using providers
        Text(
          ref.watch(requiredWinsProvider) ?? "Please enter valid values",
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 20),

        RegularButton(
          suffixIcon: false,
          withIcon: false,
          text: "Save",
          onTap: () async {
            final requiredWins = ref.read(requiredWinsProvider);
            developer.log("requiredWins: $requiredWins");
            if (requiredWins == null) {
              if (!context.mounted) return;
              informationSnackBar(
                context,
                Icons.error_outline,
                "Invalid input or you already meet your target.",
              );
              return;
            }
            final isLoading = ref.read(regularButtonLoadingProvider.notifier);
            isLoading.setLoading("saveButton", true);

            await Future.delayed(const Duration(seconds: 1));

            final converter = ConvertImages();

            final record = WinRateRecords(
              id: recordData?.id,
              backgroundImage: selectedImages.isNotEmpty
                  ? await converter.encodeImageToBase64(selectedImages.first)
                  : recordData?.backgroundImage,
              name: ref.read(nameProvider) ?? "",
              timeAdded: isUpdate
                  ? recordData!.timeAdded
                  : DateTime.now().microsecondsSinceEpoch,
              lastUpdated: isUpdate ? DateTime.now().millisecondsSinceEpoch : 0,
              desiredWinRate:
                  int.tryParse(ref.read(desiredWinRateProvider)) ?? 0,
              currentNumberOfBattles:
                  int.tryParse(ref.read(numberOfBattlesProvider)) ?? 0,
              currentWinRate: int.tryParse(ref.read(winRateProvider)) ?? 0,
            );

            if (isUpdate) {
              developer.log("ID: ${recordData!.id}");
              await RecordDatabase().updateRecord(recordData!.id!, record);
            } else {
              await RecordDatabase().insertRecord(record);
            }

            isLoading.setLoading("saveButton", false);
            if (!context.mounted) return;
            informationSnackBar(
              context,
              Icons.check_circle_outline_outlined,
              "Record has been saved!",
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          textColor: Theme.of(context).colorScheme.surface,
          buttonKey: "saveButton",
          width: double.infinity,
        ),
      ],
    );
  }
}
