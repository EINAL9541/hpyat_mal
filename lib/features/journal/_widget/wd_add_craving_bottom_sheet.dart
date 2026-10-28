import 'package:flutter/material.dart';
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
        top: context.h(20),
        left: context.w(20),
        right: context.w(20),
        bottom: MediaQuery.of(context).viewInsets.bottom + context.h(20),
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: context.borderRadius(all: 24),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: context.w(40),
                height: context.h(4),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: context.borderRadius(all: 4),
                ),
              ),
            ),
            SizedBox(height: context.h(14)),
            Text(
              "Log Craving or Check-in",
              style: AppTextStyle.headingMedium(context).copyWith(
                color: AppColors.forestDeep,
              ),
            ),
            SizedBox(height: context.h(4)),
            Text(
              "Identify patterns to build mental immunity against triggers.",
              style: AppTextStyle.captionMedium(context),
            ),

            SizedBox(height: context.h(16)),

            // Trigger selection chips
            Text(
              "Trigger",
              style: AppTextStyle.bodySemiBold(context).copyWith(
                color: AppColors.forestDeep,
              ),
            ),
            SizedBox(height: context.h(8)),
            Wrap(
              spacing: context.w(8),
              runSpacing: context.h(8),
              children: _triggers.map((t) {
                final isSelected = t == _selectedTrigger;
                return ChoiceChip(
                  label: Text(t),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedTrigger = t);
                  },
                  selectedColor: AppColors.leafSoft,
                  backgroundColor: AppColors.surfaceCardMuted,
                  labelStyle: AppTextStyle.captionMedium(context).copyWith(
                    color: isSelected
                        ? AppColors.forestPrimary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: isSelected ? AppColors.emerald : AppColors.border,
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
                  "Urge Intensity",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.forestDeep,
                  ),
                ),
                Text(
                  "${_intensity.toInt()} / 5",
                  style: AppTextStyle.bodySemiBold(context).copyWith(
                    color: AppColors.amberWarm,
                  ),
                ),
              ],
            ),
            Slider(
              value: _intensity,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: AppColors.emerald,
              inactiveColor: AppColors.border,
              onChanged: (val) => setState(() => _intensity = val),
            ),

            SizedBox(height: context.h(12)),

            // Resisted Switch
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(14),
                vertical: context.h(10),
              ),
              decoration: BoxDecoration(
                color: _resisted
                    ? AppColors.leafSoft.withValues(alpha: 0.4)
                    : AppColors.warningSoft.withValues(alpha: 0.4),
                borderRadius: context.borderRadius(all: 14),
                border: Border.all(
                  color: _resisted ? AppColors.emerald : AppColors.amberWarm,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _resisted
                              ? "I resisted the urge! 💪"
                              : "I had a slip / smoked 🍂",
                          style: AppTextStyle.bodySemiBold(context).copyWith(
                            color: _resisted
                                ? AppColors.forestPrimary
                                : const Color(0xFF9A3412),
                          ),
                        ),
                        SizedBox(height: context.h(2)),
                        Text(
                          _resisted
                              ? "+2 Dewdrops & forest thrives"
                              : "Forest enters recovery mode. Be gentle with yourself.",
                          style: AppTextStyle.captionSmall(context),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _resisted,
                    activeThumbColor: AppColors.emerald,
                    onChanged: (val) => setState(() => _resisted = val),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.h(14)),

            // Notes
            AppTextFieldWidget(
              controller: _noteController,
              maxLines: 2,
              hintText: "What helped or what were you feeling? (Optional)",
              hintStyle: AppTextStyle.captionMedium(context),
              fillColor: AppColors.surfaceCardMuted,
              borderRadius: 12,
            ),

            SizedBox(height: context.h(18)),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: context.h(48),
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
                  backgroundColor: AppColors.forestPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: context.borderRadius(all: 14),
                  ),
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
