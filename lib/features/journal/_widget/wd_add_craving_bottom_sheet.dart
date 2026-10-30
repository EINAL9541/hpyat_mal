import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';

class AddCravingBottomSheetWidget extends StatefulWidget {
  final Function({
    required String trigger,
    required int intensity,
    required bool resisted,
    required String note,
  }) onSave;

  const AddCravingBottomSheetWidget({super.key, required this.onSave});

  @override
  State<AddCravingBottomSheetWidget> createState() =>
      _AddCravingBottomSheetWidgetState();
}

class _AddCravingBottomSheetWidgetState
    extends State<AddCravingBottomSheetWidget> {
  final List<String> _triggers = [
    'Stress / Work',
    'After Meal',
    'Morning Coffee',
    'Social / Drinks',
    'Boredom / Driving',
    'Emotional Trigger',
  ];

  late String _selectedTrigger;
  double _intensity = 3.0;
  bool _resisted = true;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedTrigger = _triggers[0];
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: context.h(16),
        left: context.w(20),
        right: context.w(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + context.h(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.r(16)),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
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
            Text(
              "Log Craving",
              style: AppTextStyle.headingMedium(context).copyWith(
                color: AppColors.forestDeep,
              ),
            ),
            SizedBox(height: context.h(2)),
            Text(
              "Naming an urge takes away its power.",
              style: AppTextStyle.captionMedium(context),
            ),

            SizedBox(height: context.h(18)),

            // Outcome Selector (Resisted vs Slip — 50px Pill Options)
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _resisted = true),
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
                          color:
                              _resisted ? AppColors.emerald : AppColors.border,
                          width: _resisted ? 2.0 : 1.0,
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
                          Text(
                            "Resisted Urge",
                            style: AppTextStyle.bodySemiBold(context).copyWith(
                              fontSize: 13.5,
                              color: _resisted
                                  ? AppColors.forestDeep
                                  : AppColors.textSecondary,
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
                    onTap: () => setState(() => _resisted = false),
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
                          width: !_resisted ? 2.0 : 1.0,
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
                          Text(
                            "Had a Slip",
                            style: AppTextStyle.bodySemiBold(context).copyWith(
                              fontSize: 13.5,
                              color: !_resisted
                                  ? AppColors.forestDeep
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.h(18)),

            // Trigger selection chips (50px Full Pill)
            Text(
              "What triggered it?",
              style: AppTextStyle.bodySemiBold(context).copyWith(
                color: AppColors.forestDeep,
                fontSize: 14,
              ),
            ),
            SizedBox(height: context.h(8)),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(8),
              children: _triggers.map((t) {
                final isSelected = t == _selectedTrigger;
                return GestureDetector(
                  onTap: () => setState(() => _selectedTrigger = t),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(14),
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
                      t,
                      style: AppTextStyle.captionMedium(context).copyWith(
                        color: isSelected
                            ? AppColors.baseWhite
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: context.h(18)),

            // Intensity slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Urge Intensity",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestDeep,
                    fontSize: 14,
                  ),
                ),
                Text(
                  "${_intensity.toInt()} / 5",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestPrimary,
                    fontFeatures: const [FontFeature.tabularFigures()],
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
              controller: _noteController,
              maxLines: 2,
              hintText: "What helped or how were you feeling? (Optional)",
              hintStyle: AppTextStyle.captionMedium(context),
              fillColor: AppColors.surfaceCardMuted,
              borderRadius: 12,
            ),

            SizedBox(height: context.h(18)),

            // Save Button (50px Full Pill)
            SizedBox(
              width: double.infinity,
              height: context.h(50),
              child: ElevatedButton(
                onPressed: () {
                  widget.onSave(
                    trigger: _selectedTrigger,
                    intensity: _intensity.toInt(),
                    resisted: _resisted,
                    note: _noteController.text.trim(),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald,
                  elevation: 0,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  "Save Entry",
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
