
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';



class WebViewApp extends StatefulWidget {

  const WebViewApp({super.key});


  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {

  late WebViewController controller;
  var loadingPercentage = 0;
  var privacyPolicyUrl;

  @override
  void initState() {
    super.initState();
    requestCameraPermission();

    /*final platform = WebViewPlatform.instance;
    if (platform is AndroidWebViewPlatform) {
      platform.setOnDownloadStart((request) async {
        await _handleDownload(request.url);
      });
    }*/

    controller = WebViewController()

      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url){
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress){
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url){
          setState(() {
            loadingPercentage = 100;
          });
        },
        onWebResourceError: (WebResourceError error) {
          debugPrint('WebView Error: ${error.errorCode}, ${error.description}');
        },
        onNavigationRequest: (NavigationRequest request) {
          return _handleNavigation(request);
        },

      ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPrivacyPolicyUrl();
    });

    if (controller.platform is AndroidWebViewController) {
      final androidController = controller.platform as AndroidWebViewController;

      androidController.setOnPlatformPermissionRequest((request) {
        request.grant();
      });
    }
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {

    if (request.url.contains('.xlsx') ||
        request.url.contains('.xls') ||
        request.url.contains('.csv') ||
        request.url.contains('.pdf') ||
        request.url.contains('download') ||
        request.url.contains('export')) {

      // Handle the download
      _handleDownload(request.url);

      // Prevent WebView from navigating to the download URL
      return NavigationDecision.prevent;
    }

    // Allow normal navigation for other URLs
    return NavigationDecision.navigate;
  }

  Future<void> loadPrivacyPolicyUrl() async {

    controller.loadRequest(Uri.parse('https://fmeregistrations.com/LeadVault/Login.aspx'));

  }
  Future<void> _handleDownload(String url) async {
    try {
      // Use url_launcher to open the download in external browser
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );

        // Optional: Show a snackbar to indicate download started
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Download started in browser')),
          );
        }
      } else {
        debugPrint('Could not launch download URL: $url');
      }
    } catch (e) {
      debugPrint('Download error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
      
        body: SafeArea(
          child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: WebViewWidget(
                    controller: controller,
                  ),
                ),
                if (loadingPercentage < 100) ...[
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red, // loader in center
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      color: Colors.red,
                      value: loadingPercentage / 100.0,
                    ),
                  ),
                ]
              ],
          ),
        ),
      ),
    );
  }

  Future<bool> _handleBackNavigation() async {
    if (await controller.canGoBack()) {
      controller.goBack();
      return false; // prevent route pop
    }
    return true; // allow route pop
  }

  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
    }
    if (status.isGranted) {
      print("Camera permission granted");
    } else {
      print("Camera permission denied");
    }
  }

}