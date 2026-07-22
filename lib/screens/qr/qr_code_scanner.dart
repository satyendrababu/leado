import 'package:flutter/material.dart';
import 'package:leado/model/scanned_qr.dart';
import 'package:leado/repository/qr_repository.dart';
import 'package:leado/repository/qr_sync_repository.dart';
import 'package:leado/screens/scan_count_provider.dart';
import 'package:leado/utils/confirmation_dialog.dart';
import 'package:leado/utils/shared_pref.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:provider/provider.dart';

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({super.key});
  //final String userId;

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
  );

  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return AiBarcodeScanner(
      controller: controller,
      onDetect: (BarcodeCapture capture) async {

        //await SharedPref.clearScannedQr(); // Clear pending QR before processing new scan

        if (isScanned) return;

        final String? qrValue = capture.barcodes.first.rawValue;

        if (qrValue == null || qrValue.isEmpty) {
          return;
        }

        isScanned = true;
        controller.stop();

        debugPrint("QR Scanned : $qrValue");

        final parts = qrValue.split('\t');

        if (parts.length < 3) {
          _showMessage("Invalid QR format");
          _restartScanner();
          return;
        }

        final String edhibitorid = await SharedPref.getExhibitorId() ?? "";

        final qr = ScannedQr(
          qrcodeid: parts[0],
          firstname: parts[1],
          company: parts[2],
          exhibitorid: edhibitorid
        );
        debugPrint("Parsed QR : ${qr.qrcodeid}, ${qr.firstname}, ${qr.company}");
        /// Check duplicate
        final alreadyScanned =
            await SharedPref.isAlreadyScanned(qr.qrcodeid);

        if (alreadyScanned) {
          _showMessage("Already Scanned");
          _restartScanner();
          return;
        }

        /// Save locally
        await SharedPref.saveScannedQr(qr);

        if (!mounted) return;
          await context.read<ScanCountProvider>().loadCount();
        
        await QrRepository.sendQr({
          "qrcodeid": qr.qrcodeid,
          "firstname": qr.firstname,
          "company": qr.company,
          "exhibitorid": qr.exhibitorid,
        });

        /// Try syncing all pending QR
        final result = await QrSyncRepository.syncPendingQr();

        if (!mounted) return;

        if (result != null &&
            result.status.toLowerCase() == "success") {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => ConfirmationDialog(
              qrResponse: result,
              onPress: () {
                
                Navigator.pop(context);
          
                _restartScanner();
              },
            ),
          );
        } else {
          _showMessage(
            "Saved offline. Will sync automatically.",
          );

          _restartScanner();
        }
      },
    );
  }

  void _restartScanner() {
    if (!mounted) return;

    setState(() {
      isScanned = false;
    });

    controller.start();
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}