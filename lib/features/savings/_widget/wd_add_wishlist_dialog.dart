import 'package:flutter/material.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:hpyat_mal/core/ui/widgets/wd_text_field.dart';

class AddWishlistDialogWidget extends StatefulWidget {
  final Function(String title, double targetAmount, String iconKey) onAdd;

  const AddWishlistDialogWidget({super.key, required this.onAdd});

  @override
  State<AddWishlistDialogWidget> createState() =>
      _AddWishlistDialogWidgetState();
}

class _AddWishlistDialogWidgetState extends State<AddWishlistDialogWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  String _selectedIcon = 'gift';

  final List<Map<String, String>> _icons = [
    {'key': 'gift', 'label': 'Gift'},
    {'key': 'footprints', 'label': 'Shoes'},
    {'key': 'mountain', 'label': 'Trip'},
    {'key': 'headphones', 'label': 'Audio'},
    {'key': 'watch', 'label': 'Watch'},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: context.borderRadius(all: 20)),
      child: Padding(
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Reward Goal",
              style: AppTextStyle.headingSmall(context).copyWith(
                color: AppColors.forestDeep,
              ),
            ),
            SizedBox(height: context.h(4)),
            Text(
              "Treat yourself with money redirected from tobacco.",
              style: AppTextStyle.captionMedium(context),
            ),
            SizedBox(height: context.h(16)),
            AppTextFieldWidget(
              controller: _titleController,
              labelText: "Reward Name (e.g. Dinner with Friends)",
              borderRadius: 12,
            ),
            SizedBox(height: context.h(12)),
            AppTextFieldWidget(
              controller: _costController,
              labelText: "Target Cost (MMK)",
              isNumber: true,
              allowDecimal: true,
              borderRadius: 12,
            ),
            SizedBox(height: context.h(14)),
            Wrap(
              spacing: context.w(8),
              children: _icons.map((item) {
                final isSelected = item['key'] == _selectedIcon;
                return ChoiceChip(
                  label: Text(item['label']!),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) setState(() => _selectedIcon = item['key']!);
                  },
                  selectedColor: AppColors.leafSoft,
                  backgroundColor: AppColors.surfaceCardMuted,
                  side: BorderSide(
                    color: isSelected ? AppColors.emerald : AppColors.border,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: context.h(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancel",
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                SizedBox(width: context.w(8)),
                ElevatedButton(
                  onPressed: () {
                    final title = _titleController.text.trim();
                    final cost = double.tryParse(_costController.text.trim()) ?? 0;
                    if (title.isNotEmpty && cost > 0) {
                      widget.onAdd(title, cost, _selectedIcon);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: context.borderRadius(all: 12),
                    ),
                  ),
                  child: Text(
                    "Add Goal",
                    style: AppTextStyle.bodySemiBold(context).copyWith(
                      color: AppColors.baseWhite,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
