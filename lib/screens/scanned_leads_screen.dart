import 'package:flutter/material.dart';
import 'package:leado/model/scanned_qr.dart';
import 'package:leado/repository/email_data_repository.dart';
import 'package:leado/repository/notes_repository.dart';
import 'package:leado/repository/qr_sync_repository.dart';
import 'package:leado/utils/app_colors.dart';
import 'package:leado/utils/shared_pref.dart';
import 'package:leado/widgets/custom_drawer.dart';

class ScannedLeadsScreen extends StatefulWidget {
  const ScannedLeadsScreen({super.key});

  @override
  State<ScannedLeadsScreen> createState() => _ScannedLeadsScreenState();
}

class _ScannedLeadsScreenState extends State<ScannedLeadsScreen> {
  List<ScannedQr> scannedList = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    scannedList = await SharedPref.getScannedQrList();
    setState(() {});
  }

  Future<void> _emailData() async {
    final result = await EmailDataRepository.sendEmailData();

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Something went wrong.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    final isSuccess = result.status.toLowerCase() == "success";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.message,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor:
            isSuccess ? Colors.green.shade700 : Colors.red.shade700,
      ),
    );
  }

  Future<void> _syncSingleLead(ScannedQr qr) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Syncing ${qr.firstname}...",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.primary,
      ),
    );

    final success = await QrSyncRepository.syncSingleQr(qr);

    if (!mounted) return;

    if (success) {
      await loadData();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${qr.firstname} synced successfully",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to sync ${qr.firstname}",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Scanned Leads",
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
                color: Colors.white, // Adjust the height as needed
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

      drawer: CustomDrawer(selectedIndex: 3, onRefresh: () {}),
      body:
          scannedList.isEmpty
              ? const Center(
                child: Text("No Leads Scanned", style: TextStyle(fontSize: 18)),
              )
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _emailData,
                              icon: const Icon(
                                Icons.mail_outline,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Email Data",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton.icon(
                              onPressed: _syncData,
                              icon: const Icon(Icons.sync, color: Colors.white),
                              label: const Text(
                                "Sync All",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: Colors.blue.shade50,
                    child: Text(
                      "Total Leads : ${scannedList.length}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.separated(
                      itemCount: scannedList.length,
                      separatorBuilder:
                          (_, __) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: const Divider(height: 1, color: Colors.grey),
                          ),
                      itemBuilder: (_, index) {
                        final item = scannedList[index];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 16,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.firstname,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(item.company, style: TextStyle()),

                                    const SizedBox(height: 4),

                                    Text(
                                      "QR : ${item.qrcodeid}",
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 12),

                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  item.isSynced
                                      ? Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 18,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: Colors.green,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "Synced",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : ElevatedButton.icon(
                                        onPressed: () async {
                                          await _syncSingleLead(item);
                                        },
                                        icon: const Icon(
                                          Icons.sync,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "Sync Data",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                        ),
                                      ),
                                  const SizedBox(height: 8),
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      showAddNotesDialog(context, item);
                                    },
                                    icon: const Icon(
                                      Icons.note_add_outlined,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    label: const Text(
                                      "Add Notes",
                                      style: TextStyle(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: AppColors.primary,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      // itemBuilder: (_, index) {
                      //   final item = scannedList[index];

                      //   return ListTile(
                      //     // leading: CircleAvatar(
                      //     //   child: Text(
                      //     //     item.firstname.isNotEmpty
                      //     //         ? item.firstname[0].toUpperCase()
                      //     //         : "?",
                      //     //   ),
                      //     // ),
                      //     title: Text(
                      //       item.firstname,
                      //       style: const TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         color: AppColors.title,
                      //       ),
                      //     ),

                      //     subtitle: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           item.company,
                      //           style: const TextStyle(
                      //             color: AppColors.subtitle,
                      //           ),
                      //         ),

                      //         Text(
                      //           "QR : ${item.qrcodeid}",
                      //           style: const TextStyle(color: Colors.grey),
                      //         ),
                      //       ],
                      //     ),
                      //   );
                      // },
                    ),
                  ),
                ],
              ),
    );
  }

  Future<void> _syncData() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Syncing...",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green.shade700,
      ),
    );

    final result = await QrSyncRepository.syncPendingQr();

    if (!mounted) return;

    if (result != null && result.status.toLowerCase() == "success") {
      setState(() {}); // Reload list if you're displaying sync status

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Data synced successfully",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "No pending data to sync",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
    }
  }

  Future<void> showAddNotesDialog(BuildContext context, ScannedQr item) async {
    final noteController = TextEditingController();
    int selectedRating = 0;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              backgroundColor: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * .92,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xff156FB9),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                "View Notes",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                
                            InkWell(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                "Close",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: noteController,
                              maxLines: 5,
                              decoration: InputDecoration(
                                hintText: "Write a note",
                                hintStyle: const TextStyle(color: Colors.grey),
                                contentPadding: const EdgeInsets.all(16),
                
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                  borderSide: const BorderSide(
                                    color:
                                        AppColors.primary, // Your primary color
                                    width: 1,
                                  ),
                                ),
                
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                
                            const SizedBox(height: 18),
                
                            const Text(
                              "Rating",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                
                            const SizedBox(height: 12),
                
                            Row(
                              children: List.generate(
                                5,
                                (index) => IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  onPressed: () {
                                    setState(() {
                                      selectedRating = index + 1;
                                    });
                                  },
                                  icon: Icon(
                                    index < selectedRating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                    size: 33,
                                  ),
                                ),
                              ),
                            ),
                
                            const SizedBox(height: 20),
                
                            Center(
                              child: SizedBox(
                                width: 140,
                                height: 45,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (noteController.text.trim().isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            "Please enter notes",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                
                                    if (selectedRating == 0) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            "Please give rating",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    final exhibitorId =
                                        await SharedPref.getExhibitorId() ?? "";
                
                                    final result = await NotesRepository.addNotes(
                                      qrCodeId: item.qrcodeid,
                                      notes: noteController.text.trim(),
                                      rating: selectedRating,
                                      exhibitorId: exhibitorId,
                                    );
                
                                    if (result == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            "Something went wrong",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                
                                    if (result.status.toLowerCase() ==
                                        "success") {
                                      Navigator.pop(context);
                
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green,
                                          content: Text(
                                            result.message,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red,
                                          content: Text(
                                            result.message,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
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
            );
          },
        );
      },
    );
  }
}
