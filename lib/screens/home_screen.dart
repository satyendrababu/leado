import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:leado/model/login_page_model.dart';
import 'package:leado/screens/agenda_screen%20copy.dart';
import 'package:leado/screens/help_desk_screen.dart';
import 'package:leado/screens/dashboard_card.dart';
import 'package:leado/screens/qr/qr_code_scanner.dart';
import 'package:leado/screens/scan_count_provider.dart';
import 'package:leado/screens/scanned_leads_screen.dart';
import 'package:leado/screens/show_info/show_info_screen.dart';
import 'package:leado/utils/app_colors.dart';
import 'package:leado/utils/shared_pref.dart';
import 'package:leado/widgets/custom_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  ShowModel? selectedShow;
  int scannedCount = 0;

  @override
  void initState() {
    super.initState();
    loadData();
    requestCameraPermission();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ScanCountProvider>().loadCount();
    });

     WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkWelcomePopup();
    });
  }

 Future<void> _checkWelcomePopup() async {
  final shown = await SharedPref.isWelcomeShown();

  debugPrint("Welcome popup shown: $shown");

  if (!shown) {
    await showWelcomeDialog(context);

    await SharedPref.saveWelcomeShown(true);
  }
}
  
  Future<void> loadCount() async {
  scannedCount = await getScannedQrCount();

  if (mounted) {
    setState(() {});
  }
}
static Future<int> getScannedQrCount() async {
  final list = await SharedPref.getScannedQrList();
  return list.length;
}
  // Keep OS-level camera permission request
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      debugPrint("Camera permission granted");
    } else {
      debugPrint("Camera permission denied");
    }
  }


  Future<void> loadData() async {
    selectedShow = await SharedPref.getSelectedShow();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          "Leado",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (BuildContext buildContext) {
            return IconButton(
              icon: Image.asset(
                'assets/icons/menu-icon.png', // Your custom drawer icon path
                height: 20, 
                color: Colors.white,// Adjust the height as needed
              ),
              onPressed: () {
                Scaffold.of(buildContext).openDrawer(); // Open the drawer
              },
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                // Navigate to Scan Badge screen
                WidgetsBinding.instance.addPostFrameCallback((_) async{
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRCodeScanner()),
                );
                if (result == true) {
                    loadCount(); // Refresh your count
                  }
                });
              
              },
              icon: const Icon(
                Icons.qr_code_scanner_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        
          // Padding(
          //   padding: const EdgeInsets.only(right: 16),

          //   child: CircleAvatar(
          //     radius: 18,
          //     backgroundColor: Colors.white,
          //     child: Image.asset(
          //       'assets/icons/profile-icon.png', // Your custom profile icon path
          //       height: 24, // Adjust the height as needed
          //     ),
          //   ),
          // ),
        ],
      ),
      drawer: CustomDrawer(
        onRefresh: loadCount, // Pass the loadCount function to the drawer
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [

            /// Greeting
            SliverToBoxAdapter(
              child: _buildGreeting(),
            ),
            SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1.08,
                children: [

                  DashboardCard(
                    title: "Show Info",
                    icon: Icons.info_outline_rounded,
                    iconColor: Colors.blueGrey,
                    iconBackground: const Color(0xffEEF3F8),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ShowInfoScreen(),
                        ),
                      );
                    },
                  ),
                  
                  DashboardCard(
                    title: "Scan Badge",
                    icon: Icons.qr_code_scanner_rounded,
                    iconColor: const Color(0xff156FB9),
                    iconBackground: const Color(0xffEAF4FF),
                    onTap: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) async{
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QRCodeScanner()),
                        );
                        if (result == true) {
                          loadCount(); // Refresh your count
                        }
                      });
                    },
                  ),
                  Consumer<ScanCountProvider>(
                    builder: (context, provider, child) {
                      return DashboardCard(
                        title: "Scanned",
                        icon: Icons.grid_view_rounded,
                        iconColor: Colors.green,
                        iconBackground: const Color(0xffEAF9F1),
                        count: "Leads : ${provider.count}",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ScannedLeadsScreen()),
                          );
                        },
                      );
                    },
                  ),
                  // DashboardCard(
                  //   title: "Scanned",
                  //   icon: Icons.grid_view_rounded,
                  //   iconColor: Colors.green,
                  //   iconBackground: const Color(0xffEAF9F1),
                  //   count: "Leads : $scannedCount",
                  //   onTap: () {},
                  // ),

                  DashboardCard(
                    title: "Agenda",
                    icon: Icons.event_note_rounded,
                    iconColor: Colors.deepOrange,
                    iconBackground: const Color(0xffFFF4EB),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AgendaScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.primary,
      child: Row(
        children: [

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 8),

          const Text(
            "LEADO",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            "Welcome 👋",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.title,
            ),
          ),

          SizedBox(height: 8),

          Text(
            selectedShow?.showName ?? "",
            style: TextStyle(
              fontSize: 16,
              color: AppColors.subtitle,
            ),
          ),
        ],
      ),
    );
  }

  String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "Good Morning";
  } else if (hour >= 12 && hour < 17) {
    return "Good Afternoon";
  } else if (hour >= 17 && hour < 21) {
    return "Good Evening";
  } else {
    return "Good Night";
  }
}

Future<void> showWelcomeDialog(BuildContext context) async {

  final model = await SharedPref.getWelcomePopup();

  if (model == null) return;
  showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) {
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: MediaQuery.of(context).size.width - 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: const BoxDecoration(
                color: Color(0xff0D70B4),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      model.pageName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            /// Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        model.photo,
                        width: 150,
                      ),
                    ),

                    const SizedBox(height: 20),

                    HtmlWidget(model.popupText),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);

  }

  }