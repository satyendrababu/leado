import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:leado/model/show_info_model.dart';
import 'package:leado/utils/app_colors.dart';
import 'package:leado/utils/shared_pref.dart';
import 'package:leado/widgets/custom_drawer.dart';

class ShowInfoScreen extends StatefulWidget {
  const ShowInfoScreen({super.key});

  @override
  State<ShowInfoScreen> createState() =>
      _ShowInfoScreenState();
}

class _ShowInfoScreenState
    extends State<ShowInfoScreen> {

  ShowInfoModel? model;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    model = await SharedPref.getShowInfo();

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
      drawer: CustomDrawer(
          selectedIndex: 1,
          onRefresh: () {},
        ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: HtmlWidget(
          model!.showinfoText,
        ),
      ),
    );
  }
}