import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';

class AvailabilitySlotRow extends StatelessWidget {
  const AvailabilitySlotRow({
    super.key,
    required this.start,
    required this.end,
    required this.onStartTap,
    required this.onEndTap,
    required this.onRemove,
  });

  final TimeOfDay start;
  final TimeOfDay end;
  final VoidCallback onStartTap;
  final VoidCallback onEndTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Row(
      children: [
        Expanded(
          child: _TimeField(
            label: localizations.formatTimeOfDay(start),
            onTap: onStartTap,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          '-',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.blackShade60,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _TimeField(
            label: localizations.formatTimeOfDay(end),
            onTap: onEndTap,
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onRemove,
          child: Image.asset(
            'assets/images/delete_image.png',
            width: 24,
            height: 24,
          ),
        ),
      ],
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
          color: AppColors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.blackShade60,
              ),
            ),
            const Icon(
              Icons.access_time,
              size: 18,
              color: AppColors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

