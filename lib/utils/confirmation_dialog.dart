import 'package:flutter/material.dart';
import 'package:leado/model/qr_response.dart';

class ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? text;
  final Function? onPress;
  final QrResponse? qrResponse;

  const ConfirmationDialog(
      {super.key,
      this.title,
      this.text,
      this.onPress,
      this.qrResponse
      });

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  //final TextEditingController _remarkController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: screenSize.width * 0.9,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title ?? 'QR Data Saved',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                widget.qrResponse?.message ?? 'QR Code data has been saved successfully!',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Full Name: ${widget.qrResponse?.fullName ?? ''}",
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                "Company Name: ${widget.qrResponse?.companyName ?? ''}",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff006AD4),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text("OK", style: TextStyle(color: Colors.white),),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
