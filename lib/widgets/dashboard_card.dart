// import 'package:flutter/material.dart';
// import 'package:leado/utils/app_colors.dart';

// class DashboardCard extends StatelessWidget {
//   const DashboardCard({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.iconColor,
//     required this.iconBackground,
//     this.onTap,
//   });

//   final String title;
//   final String subtitle;

//   final IconData icon;

//   final Color iconColor;

//   final Color iconBackground;

//   final VoidCallback? onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         borderRadius: BorderRadius.circular(20),
//         onTap: onTap,
//         child: Ink(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.05),
//                 blurRadius: 15,
//                 offset: const Offset(0, 6),
//               ),
//             ],
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   height: 52,
//                   width: 52,
//                   decoration: BoxDecoration(
//                     color: iconBackground,
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                   child: Icon(
//                     icon,
//                     color: iconColor,
//                     size: 28,
//                   ),
//                 ),

//                 const Spacer(),

//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                     color: AppColors.title,
//                   ),
//                 ),

//                 const SizedBox(height: 6),

//                 Text(
//                   subtitle,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: AppColors.subtitle,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }