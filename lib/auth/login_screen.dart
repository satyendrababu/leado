import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leado/model/exhibitor_response.dart';
import 'package:leado/model/login_page_model.dart';
import 'package:leado/screens/home_screen.dart';
import 'package:leado/utils/shared_pref.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userIdController = TextEditingController();

  final List<String> shows = [
    "Intralogistics & Warehousing Show 2025",
    "Manufacturing Expo 2025",
    "Engineering Expo 2025",
  ];

  String? selectedShow;
  List<ShowModel> showsList = [];
  ShowModel? selectedShowModel;

  @override
  void initState() {
    super.initState();
    selectedShow = shows.first;
    loadExhibitors();
  }

  Future<void> loadExhibitors() async {
  showsList = await SharedPref.getShows();

  if (showsList.isNotEmpty) {
    selectedShowModel = showsList.first;
  }

  setState(() {});
}

  bool get isValid =>
      selectedShow != null && _userIdController.text.length == 4;

  String get userId => _userIdController.text;

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final poppins = GoogleFonts.poppins();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff2D84D4),
                  Color(0xff3798E9),
                  Color(0xff2D84D4),
                ],
              ),
            ),
            child: SafeArea(
                child: Center(
                    child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 18,
                        ),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: Stack(
                              children: [
                             

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 28,
                              ),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [

                                  /// Replace with your logo
                               Image.asset(
                                height: 90,
                                'assets/images/LEADO.png',
                                fit: BoxFit.cover,
                              ),

                              const SizedBox(height: 12),

                              Text(
                                "Welcome Back",
                                style: poppins.copyWith(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black,
                                ),
                              ),

                              Text(
                                "Please login to continue",
                                style: poppins.copyWith(
                                  fontSize: 16,
                                  color: const Color(0xff444444),
                                ),
                              ),

                              const SizedBox(height: 15),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Select Show",
                                  style: poppins.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),
                              DropdownButtonFormField<ShowModel>(
                              value: selectedShowModel,
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Color(0xff2D84D4),
                                  ),
                                ),
                              ),
                              items: showsList.map((show) {
                                return DropdownMenuItem<ShowModel>(
                                  value: show,
                                  child: Text(
                                    show.showName.isNotEmpty
                                        ? show.showName.trim()
                                        : show.showName.trim(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedShowModel = value;
                                });

                                debugPrint("Selected Show: ${value?.showName}");
                                debugPrint("Selected Show Code: ${value?.showCode}");
                                debugPrint("Status: ${value?.activeStatus}");
                          
                              },
                            ),
                              const SizedBox(height: 15),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "User ID (4 digits)",
                                  style: poppins.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5),

                              PinCodeTextField(
                                appContext: context,
                                controller: _userIdController,
                                length: 4,
                                keyboardType: TextInputType.number,
                                animationType: AnimationType.fade,
                                enableActiveFill: true,
                                cursorColor: const Color(0xff2D84D4),
                                textStyle: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                backgroundColor: Colors.transparent,
                                animationDuration:
                                const Duration(milliseconds: 200),
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  borderRadius:
                                  BorderRadius.circular(6),
                                  fieldHeight: 55,
                                  fieldWidth: 55,
                                  borderWidth: 1.2,

                                  inactiveColor:
                                  const Color(0xffB8B8B8),
                                  activeColor:
                                  const Color(0xff2D84D4),
                                  selectedColor:
                                  const Color(0xff2D84D4),

                                  inactiveFillColor: Colors.white,
                                  activeFillColor: Colors.white,
                                  selectedFillColor: Colors.white,
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                beforeTextPaste: (text) => false,
                              ),

                              const SizedBox(height: 10),

                          SizedBox(
                            width: 210,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: isValid
                                  ? () {
                                      FocusScope.of(context).unfocus();

                                      debugPrint("Selected Show: $selectedShowModel");
                                      debugPrint("User ID: $userId");

                                      login();
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(0xff156FB9),
                                disabledBackgroundColor:
                                    const Color(0xff156FB9).withOpacity(.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: poppins.copyWith(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          TextButton(
                            onPressed: () async {
                              // TODO: Forgot User ID
                              
                            },
                            style: TextButton.styleFrom(
                              overlayColor: Colors.transparent,
                            ),
                            child: Text(
                              "Forgot User ID?",
                              style: poppins.copyWith(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> login() async {

  final exhibitors = await SharedPref.getExhibitors();

  final exhibitor = exhibitors.where((e) {

    return e.showType == selectedShowModel?.showCode &&
        e.loginCode == _userIdController.text.trim() &&
        e.isActive;

  }).cast<ExhibitorModel?>().firstOrNull;

  if (exhibitor == null) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Invalid PIN"),
      ),
    );

    return;
  }

  await SharedPref.saveLogin(
    show: selectedShowModel!,
    exhibitor: exhibitor,
  );
  
  await SharedPref.saveWelcomeShown(false);

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    ),
  );
}
}