import 'package:flutter/material.dart';
import 'package:leado/auth/login_screen.dart';
import 'package:leado/repository/agenda_repository%20copy.dart';
import 'package:leado/repository/help_desk_repository.dart';
import 'package:leado/repository/exhibitor_repository.dart';
import 'package:leado/repository/login_repository.dart';
import 'package:leado/repository/show_info_repository.dart';
import 'package:leado/repository/welcome_popup_repository.dart';
import 'package:leado/screens/home_screen.dart';
import 'package:leado/utils/connectivity_service.dart';
import 'package:leado/utils/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    ConnectivityService.startListening();
    
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Show splash for at least 3 seconds
      await Future.delayed(const Duration(seconds: 3));

       await Future.wait([
        LoginRepository.getLoginPage(),
        ExhibitorRepository.getExhibitorList(),
        ShowInfoRepository.getShowInfo(),
        AgendaRepository.getAgenda(),
        HelpDeskRepository.getHelpDesk(),
        WelcomePopupRepository.getWelcomePopup(),
      ]);

      // Check login status
      final isLoggedIn = await SharedPref.isUserLoggedIn();

      if (isLoggedIn) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
        return;
      }

      // User not logged in, refresh master data
      await LoginRepository.getLoginPage();
      await ExhibitorRepository.getExhibitorList();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    } catch (e) {
      debugPrint("Splash Error: $e");

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.expand(
        child: Image(
          image: AssetImage(
            'assets/images/splash_image.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}