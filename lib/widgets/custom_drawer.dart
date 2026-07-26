import 'package:flutter/material.dart';
import 'package:leado/auth/login_screen.dart';
import 'package:leado/screens/help_desk_screen.dart';
import 'package:leado/screens/qr/qr_code_scanner.dart';
import 'package:leado/screens/scanned_leads_screen.dart';
import 'package:leado/screens/show_info/show_info_screen.dart';
import 'package:leado/utils/shared_pref.dart';
import 'package:leado/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onRefresh;

  const CustomDrawer({
    super.key,
    this.selectedIndex = 0,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * .78,
          height: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(22),
              bottomRight: Radius.circular(22),
            ),
          ),
          child: Column(
            children: [

              const SizedBox(height: 25),

              _drawerItem(
                context,
                index: 0,
                icon: Icons.dashboard_outlined,
                title: "Dashboard",
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              _drawerItem(
                context,
                index: 1,
                icon: Icons.info_outline,
                title: "Show Info",
                onTap: () async {
                  Navigator.pop(context); // Close drawer

                    await Future.delayed(const Duration(milliseconds: 200));

                    if (!context.mounted) return;
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ShowInfoScreen(),
                                    ),
                                  );
                },
              ),

              _drawerItem(
                context,
                index: 2,
                icon: Icons.qr_code_scanner_outlined,
                title: "Scan Badge",
                onTap: () async {
                  Navigator.pop(context);
                                    await Future.delayed(const Duration(milliseconds: 200));

                    if (!context.mounted) return;
                                  
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QRCodeScanner()),
                        );
                        if (result == true) {
                          onRefresh();
                        }
                      });
                },
              ),

              _drawerItem(
                context,
                index: 3,
                icon: Icons.grid_view_outlined,
                title: "Scanned Leads",
                onTap: () async {
                  Navigator.pop(context);
                                    await Future.delayed(const Duration(milliseconds: 200));

                    if (!context.mounted) return;
                                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ScannedLeadsScreen(),
                    ),
                  );
                },
              ),

              _drawerItem(
                context,
                index: 4,
                icon: Icons.help_outline,
                title: "Help Desk",
                onTap: () async {
                  Navigator.pop(context);
                                    await Future.delayed(const Duration(milliseconds: 200));

                    if (!context.mounted) return;
                                
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HelpDeskScreen(),
                    ),
                  );
                },
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      showLogoutDialog(context);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text(
                      "Sign Out",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final bool selected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Material(
        color: selected
            ? const Color(0xff156FB9)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            child: Row(
              children: [

                Icon(
                  icon,
                  color: selected
                      ? Colors.white
                      : Colors.black87,
                  size: 22,
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: selected
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                ),

                Icon(
                  Icons.chevron_right,
                  color: selected
                      ? Colors.white
                      : Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.red,
            ),
            SizedBox(width: 10),
            Text(
              "Sign Out",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to sign out?",
          style: TextStyle(
            fontSize: 16,
            height: 1.4,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(90, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("Cancel", style: TextStyle(color: AppColors.title)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              await SharedPref.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Sign Out"),
          ),
        ],
      );
    },
  );
}
}