import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CaboScannerWindow extends StatefulWidget {
  const CaboScannerWindow({super.key, required this.onDetectPublicId});

  final void Function(String? publicId) onDetectPublicId;

  @override
  State<CaboScannerWindow> createState() => _CaboScannerWindowState();
}

class _CaboScannerWindowState extends State<CaboScannerWindow> {
  late final MobileScannerController controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionTimeoutMs: 1000,
      returnImage: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: CaboTheme.primaryColor, width: 2),
        ),
        child: MobileScanner(
          controller: controller,
          onDetect: (capture) {
            final List<Barcode> barcodes = capture.barcodes;
            for (final barcode in barcodes) {
              debugPrint('Barcode found! ${barcode.rawValue}');
              widget.onDetectPublicId(barcode.rawValue);
            }
          },
        ),
      ),
    );
  }
}
