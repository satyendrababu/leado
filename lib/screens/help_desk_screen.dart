import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:leado/model/help_desk_model.dart';
import 'package:leado/utils/app_colors.dart';
import 'package:leado/utils/shared_pref.dart';
import 'package:leado/widgets/custom_drawer.dart';

class HelpDeskScreen extends StatefulWidget {
  const HelpDeskScreen({super.key});

  @override
  State<HelpDeskScreen> createState() =>
      _HelpDeskScreenState();
}

class _HelpDeskScreenState
    extends State<HelpDeskScreen> {

  HelpDeskModel? model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    model = await SharedPref.getHelpDesk();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (model == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
       drawer: CustomDrawer(
          selectedIndex: 4,
          onRefresh: () {},
        ),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        
        title: Text(
          model!.pageName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
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
    padding: const EdgeInsets.only(right: 12),
    child: Center(
      child: SizedBox(
        height: 36,
        child: OutlinedButton.icon(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: Colors.white,
          ),
          label: const Text(
            "Back",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    ),
  ),
],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: HtmlWidget(
          model!.helpDeskText,
        ),
      ),
    );
  }
}