import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/generate/locale_keys.g.dart';
import 'package:hpyat_mal/core/services/storage_service.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_bottom_sheet.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CravingTriggerOption {
  final String key;
  final String labelKey;
  final IconData icon;

  const CravingTriggerOption({
    required this.key,
    required this.labelKey,
    required this.icon,
  });

  static const List<CravingTriggerOption> options = [
    CravingTriggerOption(
      key: 'Stress / Work',
      labelKey: LocaleKeys.journal_triggerStress,
      icon: LucideIcons.zap,
    ),
    CravingTriggerOption(
      key: 'After Meal',
      labelKey: LocaleKeys.journal_triggerAfterMeal,
      icon: LucideIcons.utensils,
    ),
    CravingTriggerOption(
      key: 'Morning Coffee',
      labelKey: LocaleKeys.journal_triggerCoffee,
      icon: LucideIcons.coffee,
    ),
    CravingTriggerOption(
      key: 'Social / Drinks',
      labelKey: LocaleKeys.journal_triggerSocial,
      icon: LucideIcons.users,
    ),
    CravingTriggerOption(
      key: 'Boredom / Driving',
      labelKey: LocaleKeys.journal_triggerBoredom,
      icon: LucideIcons.compass,
    ),
    CravingTriggerOption(
      key: 'Emotional Trigger',
      labelKey: LocaleKeys.journal_triggerEmotional,
      icon: LucideIcons.heart,
    ),
  ];

  static String localize(String rawKey) {
    for (final opt in options) {
      if (opt.key == rawKey) return opt.labelKey.tr();
    }
    final lower = rawKey.toLowerCase();
    if (lower.contains('stress') || lower.contains('work')) {
      return LocaleKeys.journal_triggerStress.tr();
    }
    if (lower.contains('meal') || lower.contains('food')) {
      return LocaleKeys.journal_triggerAfterMeal.tr();
    }
    if (lower.contains('coffee')) {
      return LocaleKeys.journal_triggerCoffee.tr();
    }
    if (lower.contains('social') || lower.contains('drink')) {
      return LocaleKeys.journal_triggerSocial.tr();
    }
    if (lower.contains('bored') || lower.contains('driv')) {
      return LocaleKeys.journal_triggerBoredom.tr();
    }
    if (lower.contains('emotion')) {
      return LocaleKeys.journal_triggerEmotional.tr();
    }
    return rawKey;
  }

  static IconData resolveIcon(String rawKey) {
    for (final opt in options) {
      if (opt.key == rawKey) return opt.icon;
    }
    final lower = rawKey.toLowerCase();
    if (lower.contains('coffee')) return LucideIcons.coffee;
    if (lower.contains('meal') || lower.contains('food')) {
      return LucideIcons.utensils;
    }
    if (lower.contains('social') || lower.contains('drink')) {
      return LucideIcons.users;
    }
    if (lower.contains('bored') || lower.contains('driv')) {
      return LucideIcons.compass;
    }
    if (lower.contains('emotion')) return LucideIcons.heart;
    return LucideIcons.zap;
  }
}

class AddCravingBottomSheetWidget extends StatefulWidget {
  final CravingLog? initialLog;
  final Function({
    required String trigger,
    required int intensity,
    required bool resisted,
    required String note,
  })
  onSave;

  const AddCravingBottomSheetWidget({
    super.key,
    this.initialLog,
    required this.onSave,
  });

  @override
  State<AddCravingBottomSheetWidget> createState() =>
      _AddCravingBottomSheetWidgetState();
}

class _AddCravingBottomSheetWidgetState
    extends State<AddCravingBottomSheetWidget> {
  late String _selectedTriggerKey;
  late double _intensity;
  late bool _resisted;
  late final TextEditingController _noteController;

  bool get _isEditing => widget.initialLog != null;

  @override
  void initState() {
    super.initState();
    final log = widget.initialLog;
    if (log != null) {
      _selectedTriggerKey = log.trigger;
      _intensity = log.intensity.clamp(1, 5).toDouble();
      _resisted = log.resisted;
      _noteController = TextEditingController(text: log.note);
    } else {
      _selectedTriggerKey = CravingTriggerOption.options.first.key;
      _intensity = 3.0;
      _resisted = true;
      _noteController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  String _intensityDescription(int level) {
    switch (level) {
      case 1:
        return LocaleKeys.journal_intensity1.tr();
      case 2:
        return LocaleKeys.journal_intensity2.tr();
      case 3:
        return LocaleKeys.journal_intensity3.tr();
      case 4:
        return LocaleKeys.journal_intensity4.tr();
      case 5:
        return LocaleKeys.journal_intensity5.tr();
      default:
        return LocaleKeys.journal_intensity3.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLevel = _intensity.toInt();

    return Container(
      padding: EdgeInsets.only(
        top: context.h(14),
        left: context.w(20),
        right: context.w(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + context.h(20),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppSheetHandle(),
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
                        _isEditing
                            ? LocaleKeys.journal_editSheetTitle.tr()
                            : LocaleKeys.journal_logSheetTitle.tr(),
                        style: AppTextStyle.headingMedium(context)
                            .copyWith(color: AppColors.forestDeep),
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        LocaleKeys.journal_sheetSubtitle.tr(),
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

            SizedBox(height: context.h(16)),

            // Outcome Selector (Resisted vs Slip — 50px Pill Options)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _resisted = true);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        vertical: context.h(11),
                        horizontal: context.w(12),
                      ),
                      decoration: BoxDecoration(
                        color: _resisted
                            ? AppColors.leafSoft
                            : AppColors.surfaceCardMuted,
                        borderRadius: context.borderRadius(all: 50),
                        border: Border.all(
                          color: _resisted
                              ? AppColors.emerald
                              : AppColors.border,
                          width: _resisted ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.shieldCheck,
                            size: context.w(16),
                            color: _resisted
                                ? AppColors.forestPrimary
                                : AppColors.textMuted,
                          ),
                          SizedBox(width: context.w(6)),
                          Flexible(
                            child: Text(
                              LocaleKeys.journal_statusResisted.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.bodySemiBold(context)
                                  .copyWith(
                                    fontSize: 13.5,
                                    color: _resisted
                                        ? AppColors.forestDeep
                                        : AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.w(10)),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _resisted = false);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: EdgeInsets.symmetric(
                        vertical: context.h(11),
                        horizontal: context.w(12),
                      ),
                      decoration: BoxDecoration(
                        color: !_resisted
                            ? AppColors.amberLight
                            : AppColors.surfaceCardMuted,
                        borderRadius: context.borderRadius(all: 50),
                        border: Border.all(
                          color: !_resisted
                              ? AppColors.amberWarm
                              : AppColors.border,
                          width: !_resisted ? 1.8 : 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.rotateCcw,
                            size: context.w(16),
                            color: !_resisted
                                ? AppColors.amberWarm
                                : AppColors.textMuted,
                          ),
                          SizedBox(width: context.w(6)),
                          Flexible(
                            child: Text(
                              LocaleKeys.journal_statusSlip.tr(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.bodySemiBold(context)
                                  .copyWith(
                                    fontSize: 13.5,
                                    color: !_resisted
                                        ? AppColors.forestDeep
                                        : AppColors.textSecondary,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.h(16)),

            // Trigger selection chips (50px Full Pill)
            Text(
              LocaleKeys.journal_triggerQuestion.tr(),
              style: AppTextStyle.bodySemiBold(
                context,
              ).copyWith(color: AppColors.forestDeep, fontSize: 14.5),
            ),
            SizedBox(height: context.h(8)),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(8),
              children: CravingTriggerOption.options.map((opt) {
                final isSelected = opt.key == _selectedTriggerKey;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedTriggerKey = opt.key);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(13),
                      vertical: context.h(7),
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
                    child: Text(
                      opt.labelKey.tr(),
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: isSelected
                            ? AppColors.baseWhite
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(16)),

            // Intensity slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  LocaleKeys.journal_intensityLabel.tr(),
                  style: AppTextStyle.bodySemiBold(
                    context,
                  ).copyWith(color: AppColors.forestDeep, fontSize: 14.5),
                ),
                Flexible(
                  child: Text(
                    "$currentLevel / 5 · ${_intensityDescription(currentLevel)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.captionMedium(context).copyWith(
                      color: AppColors.forestPrimary,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
              ),
              child: Slider(
                value: _intensity,
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: AppColors.emerald,
                inactiveColor: AppColors.border,
                onChanged: (val) => setState(() => _intensity = val),
              ),
            ),

            SizedBox(height: context.h(8)),

            // Notes
            AppTextFieldWidget(
              label: LocaleKeys.journal_noteLabel.tr(),
              controller: _noteController,
              maxLines: 2,
              hintText: LocaleKeys.journal_noteHint.tr(),
              borderRadius: 12,
            ),

            SizedBox(height: context.h(18)),

            // Save Button (48px Full Pill)
            SizedBox(
              width: double.infinity,
              height: context.h(48),
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  widget.onSave(
                    trigger: _selectedTriggerKey,
                    intensity: _intensity.toInt(),
                    resisted: _resisted,
                    note: _noteController.text.trim(),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  foregroundColor: AppColors.baseWhite,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  _isEditing
                      ? LocaleKeys.journal_saveChangesBtn.tr()
                      : LocaleKeys.journal_saveEntryBtn.tr(),
                  style: AppTextStyle.bodySemiBold(
                    context,
                  ).copyWith(color: AppColors.baseWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
