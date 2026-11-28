import 'dart:async';

import 'package:cabo/common/presentation/widgets/cabo_theme.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CaboScannerWindow extends StatefulWidget {
  const CaboScannerWindow({super.key, required this.onDetectPublicId});

  final void Function(String? publicId) onDetectPublicId;

  @override
  State<CaboScannerWindow> createState() => _CaboScannerWindowState();
}

class _CaboScannerWindowState extends State<CaboScannerWindow>
    with SingleTickerProviderStateMixin {
  late final MobileScannerController controller;
  late final AnimationController _scanLineController;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController(
      detectionTimeoutMs: 1000,
      returnImage: true,
    );
    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    unawaited(_scanLineController.repeat(reverse: true));
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    unawaited(controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: 280,
      decoration: BoxDecoration(
        color: CaboTheme.surfaceContainer,
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        border: Border.all(color: CaboTheme.outlineVariant),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: CaboTheme.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(CaboTheme.cardRadius),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final Barcode barcode in barcodes) {
                  debugPrint('Barcode found! ${barcode.rawValue}');
                  widget.onDetectPublicId(barcode.rawValue);
                }
              },
            ),
            _buildScannerOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Center(
      child: SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          children: <Widget>[
            _corner(isTop: true, isLeft: true),
            _corner(isTop: true, isLeft: false),
            _corner(isTop: false, isLeft: true),
            _corner(isTop: false, isLeft: false),
            AnimatedBuilder(
              animation: _scanLineController,
              builder: (BuildContext context, Widget? child) {
                return Align(
                  alignment: Alignment(0, _scanLineController.value * 2 - 1),
                  child: child,
                );
              },
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      CaboTheme.scanLineFade,
                      CaboTheme.primaryContainer,
                      CaboTheme.scanLineFade,
                    ],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: CaboTheme.primaryContainer.withValues(alpha: 0.8),
                      blurRadius: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corner({required bool isTop, required bool isLeft}) {
    final BorderSide side = BorderSide(
      color: CaboTheme.primaryContainer,
      width: 4,
    );
    return Align(
      alignment: Alignment(isLeft ? -1 : 1, isTop ? -1 : 1),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border(
            top: isTop ? side : BorderSide.none,
            bottom: isTop ? BorderSide.none : side,
            left: isLeft ? side : BorderSide.none,
            right: isLeft ? BorderSide.none : side,
          ),
          borderRadius: BorderRadius.only(
            topLeft: isTop && isLeft ? const Radius.circular(12) : Radius.zero,
            topRight: isTop && !isLeft
                ? const Radius.circular(12)
                : Radius.zero,
            bottomLeft: !isTop && isLeft
                ? const Radius.circular(12)
                : Radius.zero,
            bottomRight: !isTop && !isLeft
                ? const Radius.circular(12)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}
