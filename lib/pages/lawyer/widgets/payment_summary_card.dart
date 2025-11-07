import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';

enum LawyerPaymentMethod { card, upi }

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({
    super.key,
    required this.feeBreakdown,
    required this.totalFee,
    required this.selectedMethod,
    required this.onMethodChanged,
    required this.upiController,
    required this.onPayNow,
    required this.isSubmitting,
  });

  final Map<String, double> feeBreakdown;
  final double totalFee;
  final LawyerPaymentMethod selectedMethod;
  final ValueChanged<LawyerPaymentMethod> onMethodChanged;
  final TextEditingController upiController;
  final VoidCallback onPayNow;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.white,
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUMMARY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackShade60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...feeBreakdown.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              entry.key,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                            Text(
                              '₹${entry.value.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.blackShade60,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackShade60,
                          ),
                        ),
                        Text(
                          '₹${totalFee.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.blackShade60,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.blackShade60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _PaymentChip(
                          label: 'Card',
                          isSelected: selectedMethod == LawyerPaymentMethod.card,
                          onTap: () => onMethodChanged(LawyerPaymentMethod.card),
                        ),
                        const SizedBox(width: 12),
                        _PaymentChip(
                          label: 'UPI',
                          isSelected: selectedMethod == LawyerPaymentMethod.upi,
                          onTap: () => onMethodChanged(LawyerPaymentMethod.upi),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (selectedMethod == LawyerPaymentMethod.upi) ...[
                      TextField(
                        controller: upiController,
                        decoration: const InputDecoration(
                          labelText: 'UPI ID',
                          hintText: 'username@ybl',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isSubmitting ? null : onPayNow,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: AppColors.blackShade60,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : Text('Pay ₹${totalFee.toStringAsFixed(0)} Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.blackShade60,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.grey,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _PaymentChip extends StatelessWidget {
  const _PaymentChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.blackShade60 : AppColors.borderColor,
            width: 1.2,
          ),
          color: isSelected
              ? AppColors.blackShade60
              : AppColors.lightGrey.withOpacity(0.3),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.white : AppColors.blackShade60,
          ),
        ),
      ),
    );
  }
}

