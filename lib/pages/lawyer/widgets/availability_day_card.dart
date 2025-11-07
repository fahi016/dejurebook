import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';
import 'package:dejurebook/models/lawyer_profile.dart';
import 'package:dejurebook/pages/lawyer/widgets/availability_slot_row.dart';

class AvailabilityDayCard extends StatelessWidget {
  const AvailabilityDayCard({
    super.key,
    required this.weekday,
    required this.slots,
    required this.onAddSlot,
    required this.onDuplicate,
    required this.onRemoveSlot,
    required this.onStartTimeTap,
    required this.onEndTimeTap,
  });

  final LawyerWeekday weekday;
  final List<LawyerAvailabilitySlot> slots;
  final VoidCallback onAddSlot;
  final VoidCallback onDuplicate;
  final ValueChanged<int> onRemoveSlot;
  final ValueChanged<int> onStartTimeTap;
  final ValueChanged<int> onEndTimeTap;

  bool get _isWeekend =>
      weekday == LawyerWeekday.saturday || weekday == LawyerWeekday.sunday;

  @override
  Widget build(BuildContext context) {
    final hasSlots = slots.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                weekday.shortLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.blackShade60,
                ),
              ),
              const SizedBox(width: 12),
              if (!hasSlots)
                Text(
                  'Unavailable',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.grey.withOpacity(0.9),
                  ),
                ),
              const Spacer(),
              if (hasSlots) ...[
                GestureDetector(
                  onTap: onDuplicate,
                  child: Image.asset(
                    'assets/images/transfer_image.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                const SizedBox(width: 12),
              ],
              GestureDetector(
                onTap: onAddSlot,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderColor),
                    color: hasSlots
                        ? AppColors.white
                        : AppColors.lightGrey.withOpacity(0.35),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.add,
                        size: 16,
                        color: AppColors.blackShade60,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (hasSlots) ...[
            const SizedBox(height: 16),
            ...List.generate(slots.length, (index) {
              final slot = slots[index];
              return Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 12),
                child: AvailabilitySlotRow(
                  start: slot.start,
                  end: slot.end,
                  onStartTap: () => onStartTimeTap(index),
                  onEndTap: () => onEndTimeTap(index),
                  onRemove: () => onRemoveSlot(index),
                ),
              );
            }),
          ],
          if (!hasSlots && !_isWeekend) ...[
            const SizedBox(height: 16),
            Text(
              'Tap + to add your availability',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey,
              ),
            ),
          ],
          if (!hasSlots && _isWeekend) ...[
            const SizedBox(height: 16),
            Text(
              'Weekends off? You can always add slots later.',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

