import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_camera_capture_screen.dart';
import 'package:hpyat_mal/features/savings/_widget/wd_square_image_cropper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class GoalIconOption {
  final String key;
  final String label;
  final IconData icon;

  const GoalIconOption({
    required this.key,
    required this.label,
    required this.icon,
  });

  static const List<GoalIconOption> options = [
    GoalIconOption(key: 'gift', label: 'Treat', icon: LucideIcons.gift),
    GoalIconOption(key: 'coffee', label: 'Cafe', icon: LucideIcons.coffee),
    GoalIconOption(
      key: 'utensils',
      label: 'Dining',
      icon: LucideIcons.utensils,
    ),
    GoalIconOption(
      key: 'headphones',
      label: 'Audio',
      icon: LucideIcons.headphones,
    ),
    GoalIconOption(
      key: 'footprints',
      label: 'Gear',
      icon: LucideIcons.footprints,
    ),
    GoalIconOption(
      key: 'watch',
      label: 'Style',
      icon: LucideIcons.watch,
    ),
    GoalIconOption(
      key: 'smartphone',
      label: 'Tech',
      icon: LucideIcons.smartphone,
    ),
    GoalIconOption(
      key: 'mountain',
      label: 'Trip',
      icon: LucideIcons.mountain,
    ),
    GoalIconOption(
      key: 'book',
      label: 'Book',
      icon: LucideIcons.bookOpen,
    ),
    GoalIconOption(
      key: 'sparkles',
      label: 'Self-Care',
      icon: LucideIcons.sparkles,
    ),
  ];

  static IconData resolve(String key) {
    for (final opt in options) {
      if (opt.key == key) return opt.icon;
    }
    return LucideIcons.gift;
  }
}

class AddWishlistDialogWidget extends StatefulWidget {
  final Function(
    String title,
    double targetAmount,
    String iconKey,
    String? imagePath,
  ) onAdd;
  final String currencyUnit;
  final WishlistItem? initialItem;
  final String? presetTitle;
  final double? presetAmount;
  final String? presetIconKey;

  const AddWishlistDialogWidget({
    super.key,
    required this.onAdd,
    this.currencyUnit = 'MMK',
    this.initialItem,
    this.presetTitle,
    this.presetAmount,
    this.presetIconKey,
  });

  @override
  State<AddWishlistDialogWidget> createState() =>
      _AddWishlistDialogWidgetState();
}

class _AddWishlistDialogWidgetState extends State<AddWishlistDialogWidget> {
  late final TextEditingController _titleController;
  late final TextEditingController _costController;
  final ImagePicker _picker = ImagePicker();
  String? _imagePath;
  late String _selectedIconKey;
  String? _errorMessage;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _titleController = TextEditingController(
      text: item?.title ?? widget.presetTitle ?? '',
    );
    final initialAmount = item?.targetAmount ?? widget.presetAmount;
    _costController = TextEditingController(
      text: initialAmount != null
          ? (initialAmount == initialAmount.roundToDouble()
              ? initialAmount.toInt().toString()
              : initialAmount.toString())
          : '',
    );
    _imagePath = item?.imagePath;
    _selectedIconKey = item?.iconKey ?? widget.presetIconKey ?? 'gift';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _cropAndSetImage(String sourcePath) async {
    try {
      final CroppedFile? cropped = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 90,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Goal Photo',
            toolbarColor: AppColors.forestDeep,
            toolbarWidgetColor: AppColors.baseWhite,
            statusBarLight: false,
            navBarLight: false,
            backgroundColor: AppColors.surface,
            activeControlsWidgetColor: AppColors.emerald,
            dimmedLayerColor: AppColors.forestDeep.withValues(alpha: 0.72),
            cropFrameColor: AppColors.emerald,
            cropGridColor: AppColors.leafSoft,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            aspectRatioPresets: const [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            title: 'Crop Goal Photo',
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            aspectRatioPresets: const [
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );

      if (cropped != null && mounted) {
        HapticFeedback.selectionClick();
        setState(() => _imagePath = cropped.path);
      }
    } catch (_) {
      if (!mounted) return;
      final String? fallbackCroppedPath = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (_) => SquareImageCropperScreen(sourcePath: sourcePath),
        ),
      );
      if (fallbackCroppedPath != null && mounted) {
        HapticFeedback.selectionClick();
        setState(() => _imagePath = fallbackCroppedPath);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1440,
        maxHeight: 1440,
      );
      if (file != null && mounted) {
        await _cropAndSetImage(file.path);
      }
    } catch (_) {}
  }

  Future<void> _captureFromCamera() async {
    final String? capturedPath = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => const CameraCaptureScreen(),
      ),
    );
    if (capturedPath != null && mounted) {
      await _cropAndSetImage(capturedPath);
    }
  }

  void _showImageSourceSheet() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(16)),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(16),
            vertical: context.h(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: context.w(36),
                height: context.h(4),
                margin: EdgeInsets.only(bottom: context.h(12)),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: context.borderRadius(all: 4),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(context.w(8)),
                  decoration: BoxDecoration(
                    color: AppColors.leafSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.camera,
                    size: context.w(18),
                    color: AppColors.forestPrimary,
                  ),
                ),
                title: Text(
                  "Take a Photo",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestDeep,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _captureFromCamera();
                },
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(context.w(8)),
                  decoration: BoxDecoration(
                    color: AppColors.leafSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    LucideIcons.image,
                    size: context.w(18),
                    color: AppColors.forestPrimary,
                  ),
                ),
                title: Text(
                  "Choose from Gallery",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestDeep,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromGallery();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final title = _titleController.text.trim();
    final cost = double.tryParse(
          _costController.text.replaceAll(',', '').trim(),
        ) ??
        0;

    if (title.isEmpty) {
      setState(() => _errorMessage = "Please enter a name for your goal.");
      return;
    }
    if (cost <= 0) {
      setState(() => _errorMessage = "Please enter a valid target amount.");
      return;
    }

    HapticFeedback.mediumImpact();
    widget.onAdd(title, cost, _selectedIconKey, _imagePath);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final hasValidImage =
        _imagePath != null && File(_imagePath!).existsSync();

    return Container(
      padding: EdgeInsets.only(
        top: context.h(14),
        left: context.w(20),
        right: context.w(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + context.h(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(20)),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: context.w(36),
                height: context.h(4),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: context.borderRadius(all: 4),
                ),
              ),
            ),
            SizedBox(height: context.h(16)),

            // Header with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? "Edit Reward Goal" : "New Reward Goal",
                        style: AppTextStyle.headingMedium(context).copyWith(
                          color: AppColors.forestDeep,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        "Turn money saved from skipping cigarettes into something meaningful.",
                        style: AppTextStyle.captionMedium(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.w(8)),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: context.borderRadius(all: 50),
                  child: Container(
                    padding: EdgeInsets.all(context.w(6)),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceCardMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      LucideIcons.x,
                      size: context.w(16),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.h(18)),

            // 1. Photo or Icon Visual Picker
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _showImageSourceSheet,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: context.w(68),
                        height: context.w(68),
                        decoration: BoxDecoration(
                          color: AppColors.leafSoft,
                          borderRadius: context.borderRadius(all: 16),
                          border: Border.all(
                            color: AppColors.emerald.withValues(alpha: 0.4),
                            width: 1.5,
                          ),
                        ),
                        child: hasValidImage
                            ? ClipRRect(
                                borderRadius: context.borderRadius(all: 14),
                                child: Image.file(
                                  File(_imagePath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                GoalIconOption.resolve(_selectedIconKey),
                                size: context.w(28),
                                color: AppColors.forestPrimary,
                              ),
                      ),
                      Positioned(
                        bottom: -context.h(4),
                        right: -context.w(4),
                        child: Container(
                          padding: EdgeInsets.all(context.w(5)),
                          decoration: BoxDecoration(
                            color: AppColors.emerald,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.surfaceCard,
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            LucideIcons.camera,
                            size: context.w(11),
                            color: AppColors.baseWhite,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: context.w(14)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasValidImage
                            ? "Custom Goal Photo Added"
                            : "Add a Photo or Pick an Icon",
                        style: AppTextStyle.bodySemiBold(context).copyWith(
                          color: AppColors.forestDeep,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        hasValidImage
                            ? "Tap photo to replace, or crop/remove below."
                            : "Tap the badge to upload a 1:1 photo, or select a category icon below.",
                        style: AppTextStyle.captionSmall(context).copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      if (hasValidImage) ...[
                        SizedBox(height: context.h(8)),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _cropAndSetImage(_imagePath!),
                              borderRadius: context.borderRadius(all: 50),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(10),
                                  vertical: context.h(4),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceCardMuted,
                                  borderRadius: context.borderRadius(all: 50),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.crop,
                                      size: context.w(12),
                                      color: AppColors.forestPrimary,
                                    ),
                                    SizedBox(width: context.w(4)),
                                    Text(
                                      "Crop",
                                      style: AppTextStyle.captionSmall(context)
                                          .copyWith(
                                        color: AppColors.forestPrimary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: context.w(8)),
                            InkWell(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() => _imagePath = null);
                              },
                              borderRadius: context.borderRadius(all: 50),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.w(10),
                                  vertical: context.h(4),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.dangerSoft,
                                  borderRadius: context.borderRadius(all: 50),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      LucideIcons.trash2,
                                      size: context.w(12),
                                      color: AppColors.danger,
                                    ),
                                    SizedBox(width: context.w(4)),
                                    Text(
                                      "Remove",
                                      style: AppTextStyle.captionSmall(context)
                                          .copyWith(
                                        color: AppColors.danger,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: context.h(14)),

            // Horizontal Icon Selector
            SizedBox(
              height: context.h(38),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: GoalIconOption.options.length,
                separatorBuilder: (_, _) => SizedBox(width: context.w(8)),
                itemBuilder: (context, index) {
                  final option = GoalIconOption.options[index];
                  final isSelected = _selectedIconKey == option.key;
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _selectedIconKey = option.key);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(12),
                        vertical: context.h(6),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.emerald
                            : AppColors.surfaceCardMuted,
                        borderRadius: context.borderRadius(all: 50),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.emerald
                              : AppColors.borderSubtle,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            option.icon,
                            size: context.w(14),
                            color: isSelected
                                ? AppColors.baseWhite
                                : AppColors.textSecondary,
                          ),
                          SizedBox(width: context.w(6)),
                          Text(
                            option.label,
                            style: AppTextStyle.captionSmall(context).copyWith(
                              color: isSelected
                                  ? AppColors.baseWhite
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: context.h(18)),

            // 2. Reward Name
            AppTextFieldWidget(
              label: "Goal Name",
              controller: _titleController,
              hintText: "e.g. Specialty Coffee Beans, Running Shoes",
              textCapitalization: TextCapitalization.words,
              borderRadius: 12,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
            ),
            SizedBox(height: context.h(14)),

            // 3. Target Cost
            AppTextFieldWidget(
              label: "Target Amount",
              controller: _costController,
              hintText: "35000",
              isNumber: true,
              allowDecimal: true,
              unit: widget.currencyUnit,
              borderRadius: 12,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() => _errorMessage = null);
                }
              },
            ),

            if (_errorMessage != null) ...[
              SizedBox(height: context.h(10)),
              Text(
                _errorMessage!,
                style: AppTextStyle.captionSmall(context).copyWith(
                  color: AppColors.danger,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],

            SizedBox(height: context.h(20)),

            // Primary Full-Width 50px Pill Button
            SizedBox(
              width: double.infinity,
              height: context.h(50),
              child: ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.baseWhite,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  _isEditing ? "Save Changes" : "Create Goal",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.baseWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
