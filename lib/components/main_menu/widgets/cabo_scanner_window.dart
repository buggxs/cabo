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
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanLineController.dispose();
    controller.dispose();
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
            color: Color(0x143D3A35),
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
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                for (final barcode in barcodes) {
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
            // Eck-Akzente
            _corner(top: true, left: true),
            _corner(top: true, left: false),
            _corner(top: false, left: true),
            _corner(top: false, left: false),
            // Animierte Scan-Linie
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
                      const Color(0x00F28C38),
                      CaboTheme.primaryContainer,
                      const Color(0x00F28C38),
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

  Widget _corner({required bool top, required bool left}) {
    final BorderSide side = BorderSide(
      color: CaboTheme.primaryContainer,
      width: 4,
    );
    return Align(
      alignment: Alignment(left ? -1 : 1, top ? -1 : 1),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border(
            top: top ? side : BorderSide.none,
            bottom: top ? BorderSide.none : side,
            left: left ? side : BorderSide.none,
            right: left ? BorderSide.none : side,
          ),
          borderRadius: BorderRadius.only(
            topLeft: top && left ? const Radius.circular(12) : Radius.zero,
            topRight: top && !left ? const Radius.circular(12) : Radius.zero,
            bottomLeft: !top && left ? const Radius.circular(12) : Radius.zero,
            bottomRight: !top && !left
                ? const Radius.circular(12)
                : Radius.zero,
          ),
        ),
      ),
    );
  }
}
