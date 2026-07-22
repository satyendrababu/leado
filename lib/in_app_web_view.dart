import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:leado/screens/qr/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async'; // Needed for Future

// --- Boilerplate setup (Assuming this is your main widget) ---

// Define the widget based on the user's state class context
class WebViewApp extends StatefulWidget {
  const WebViewApp({super.key});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

// --- Converted State Class using flutter_inappwebview ---

class _WebViewAppState extends State<WebViewApp> {

  // 1. Use InAppWebViewController
  InAppWebViewController? controller;
  var loadingPercentage = 0;
  final String initialUrl = 'https://fmeregistrations.com/LeadVault/Login.aspx';

  @override
  void initState() {
    super.initState();
    // Request OS-level camera permission proactively
    requestCameraPermission();

    // Flutter InAppWebView setup is mostly done directly within the InAppWebView widget in the build method.
    // We can remove the complex controller setup from initState.
  }

  // Helper method to handle downloads (remains largely the same)
  Future<void> _handleDownload(String url) async {
    try {
      // Use url_launcher to open the download in external browser
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );

        // Optional: Show a snackbar to indicate download started
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Download started in browser')),
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

  // 2. Navigation interception and download handling (Replaces _handleNavigation)
  Future<NavigationActionPolicy> _shouldOverrideUrlLoading(
      InAppWebViewController controller, NavigationAction navigationAction) async {

    final url = navigationAction.request.url?.toString() ?? '';

    // Check for specific file extensions or download/export keywords
    debugPrint("kya-->> ${url}");
    if (url.contains('leadscan')) {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRCodeScanner()),
          );
        });
      }
      // CANCEL the navigation - prevent WebView from loading this URL
      return NavigationActionPolicy.CANCEL;
    }
    if (url.contains('.xlsx') ||
        url.contains('.xls') ||
        url.contains('.csv') ||
        url.contains('.pdf') ||
        url.contains('download') ||
        url.contains('export')) {

      // Handle the download externally
      //_handleDownload(url);

      // Prevent WebView from navigating to the download URL
      return NavigationActionPolicy.CANCEL;
    }

    // Allow normal navigation for other URLs
    return NavigationActionPolicy.ALLOW;
  }

  // 3. Permission Request Handler (Replaces AndroidWebViewController's platform request)
  Future<PermissionResponse> _onPermissionRequest(
      InAppWebViewController controller, PermissionRequest request) async {

    // Automatically grant camera permission if requested by the web content
    if (request.resources.contains(PermissionResourceType.CAMERA)) {
      return PermissionResponse(
        resources: request.resources,
        action: PermissionResponseAction.GRANT,
      );
    }

    // Grant other permissions by default
    return PermissionResponse(
      resources: request.resources,
      action: PermissionResponseAction.GRANT,
    );
  }

  // 4. Back navigation handler update
  Future<bool> _handleBackNavigation() async {
    // Safely check if controller is available and can go back
    if (await controller?.canGoBack() ?? false) {
      controller?.goBack();
      return false; // prevent route pop
    }
    return true; // allow route pop (exit app)
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackNavigation,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              // 5. Use InAppWebView widget
              InAppWebView(
                // Load the initial URL
                initialUrlRequest: URLRequest(url: WebUri(initialUrl)),

                // Set initial settings (equivalent to JavaScriptMode.unrestricted)
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  // Configure Android specific settings if needed
                  allowFileAccess: true,
                  allowContentAccess: true,
                  // Hide scrollbars if desired
                  verticalScrollBarEnabled: false,
                  sharedCookiesEnabled: true,
                  clearCache: false
                ),

                // Set the controller once the WebView is created
                onWebViewCreated: (controller) {
                  this.controller = controller;
                },

                // Update progress percentage
                onProgressChanged: (controller, progress) {
                  setState(() {
                    loadingPercentage = progress;
                  });
                },

                // Start loading/page finished callbacks
                onLoadStart: (controller, url) {
                  setState(() {
                    loadingPercentage = 0;
                  });
                },
                onLoadStop: (controller, url) {
                  setState(() {
                    loadingPercentage = 100;
                  });
                },

                // Handle web view errors
                onLoadError: (controller, url, code, message) {
                  debugPrint('InAppWebView Error: $code, $message');
                },

                // Intercept navigation for download files (replaces NavigationDelegate logic)
                shouldOverrideUrlLoading: _shouldOverrideUrlLoading,

                // Handle web permissions (e.g., camera access)
                onPermissionRequest: _onPermissionRequest,

                onDownloadStartRequest: (controller, downloadStartRequest) async {
                  //final url = downloadStartRequest.url.toString();
                  final url = "https://fmeregistrations.com/LeadVault/ReportAllUsers.aspx";
                  debugPrint("Download requested: $url");
                  await _handleDownload(url);

                  controller.stopLoading();
                  if (mounted && Navigator.canPop(context)) {
                    Navigator.of(context).pop();
                  }
                },
              ),

              // Loading indicators (kept the same logic)
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
}