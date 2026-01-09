import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../config/theme/color/colors.dart';
import '../../main.dart';

class ImportFileContainerWidget extends StatelessWidget {
  final VoidCallback onTap;
  const ImportFileContainerWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(12),
          strokeWidth: 2,
          dashPattern: const [8, 4],
          color: currentTheme.borderColor,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            color: currentTheme
                .secondary
                .withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_upload_outlined,
                size: 56,
                color: currentTheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Drag & Drop or Click to Upload',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color:
                      currentTheme
                          .textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Select a file from your device',
                style: TextStyle(
                  fontSize: 14,
                  color:
                      currentTheme
                          .textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
