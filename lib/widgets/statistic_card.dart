import 'package:flutter/material.dart';
import 'package:leado/utils/app_colors.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({
    super.key,
    required this.total,
    this.onTap,
  });

  final int total;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.analytics_outlined,
                    color: AppColors.green,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Scanned Leads",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: AppColors.title,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Text(
                "$total",
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: AppColors.green,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                "Total Leads Captured",
                style: TextStyle(
                  color: AppColors.subtitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}