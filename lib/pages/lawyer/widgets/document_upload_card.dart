import 'package:flutter/material.dart';
import 'package:dejurebook/constants/app_colors.dart';

class DocumentUploadCard extends StatelessWidget {
  const DocumentUploadCard({
    super.key,
    required this.onPickFile,
    this.fileName,
    this.fileSizeLabel,
  });

  final VoidCallback onPickFile;
  final String? fileName;
  final String? fileSizeLabel;

  @override
  Widget build(BuildContext context) {
    final hasFile = fileName != null && fileName!.isNotEmpty;

    return GestureDetector(
      onTap: onPickFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.borderColor,
            style: BorderStyle.solid,
          ),
          color: AppColors.surfaceLight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const Icon(
                Icons.cloud_upload_outlined,
                color: AppColors.blackShade60,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasFile ? fileName! : 'Drag and Drop files here',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.blackShade60,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFile
                  ? (fileSizeLabel ?? '')
                  : 'Files supported: PDF, XLS, Image, Scanner',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.white,
                border: Border.all(color: AppColors.borderColor),
              ),
              child: const Text(
                'Choose File',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.blackShade60,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Maximum size: 5MB',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

