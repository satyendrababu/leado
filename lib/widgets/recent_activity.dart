import 'package:flutter/material.dart';
import 'package:leado/utils/app_colors.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final activities = [
      ("ABC Industries", "10:30 AM"),
      ("Tata Steel", "10:18 AM"),
      ("JSW Pvt Ltd", "09:52 AM"),
      ("Reliance", "09:21 AM"),
    ];

    return Container(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.title,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("View All"),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (_, __) => const Divider(
              height: 1,
              indent: 72,
            ),
            itemBuilder: (_, index) {
              return ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20),

                leading: Container(
                  height: 46,
                  width: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xffE8F7EE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: AppColors.green,
                  ),
                ),

                title: Text(
                  activities[index].$1,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                subtitle: const Text(
                  "Lead captured successfully",
                ),

                trailing: Text(
                  activities[index].$2,
                  style: const TextStyle(
                    color: AppColors.subtitle,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}