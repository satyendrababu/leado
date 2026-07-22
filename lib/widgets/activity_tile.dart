import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ActivityTile extends StatelessWidget {
  final String companyName;
  final String time;
  final bool isSuccess;
  final VoidCallback? onTap;

  const ActivityTile({
    super.key,
    required this.companyName,
    required this.time,
    this.isSuccess = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        child: Row(
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: isSuccess
                    ? const Color(0xFFEAF9F1)
                    : const Color(0xFFFFF4E5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSuccess
                    ? Icons.check_rounded
                    : Icons.schedule_rounded,
                color: isSuccess
                    ? AppColors.green
                    : AppColors.orange,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Text(
                companyName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.title,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 12),

            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.subtitle,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}