import 'package:flutter/material.dart';

import 'corner_painter.dart';

class ScannerOverlay extends StatelessWidget {
  const ScannerOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double scanSize = size.width * 0.7;

    return Stack(
      children: [
        /// Dark overlay
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
                color: Colors.black,
              ),
              Center(
                child: Container(
                  width: scanSize,
                  height: scanSize,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),

        /// White border corners
        Center(
          child: SizedBox(
            width: scanSize,
            height: scanSize,
            child: CustomPaint(
              painter: CornerPainter(),
            ),
          ),
        ),
      ],
    );
  }
}
