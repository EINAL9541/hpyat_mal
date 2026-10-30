import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Pure-Flutter 1:1 Square Image Cropper Screen themed with [AppColors].
/// Used as a reliable fallback if the native [ImageCropper] plugin is not yet
/// registered (e.g. after hot reload without a full native rebuild).
class SquareImageCropperScreen extends StatefulWidget {
  final String sourcePath;

  const SquareImageCropperScreen({super.key, required this.sourcePath});

  @override
  State<SquareImageCropperScreen> createState() =>
      _SquareImageCropperScreenState();
}

class _SquareImageCropperScreenState extends State<SquareImageCropperScreen> {
  final GlobalKey _cropBoundaryKey = GlobalKey();
  final TransformationController _transformController =
      TransformationController();
  int _quarterTurns = 0;
  bool _isSaving = false;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _rotateRight() {
    HapticFeedback.selectionClick();
    setState(() {
      _quarterTurns = (_quarterTurns + 1) % 4;
    });
  }

  void _resetTransform() {
    HapticFeedback.selectionClick();
    setState(() {
      _quarterTurns = 0;
      _transformController.value = Matrix4.identity();
    });
  }

  Future<void> _saveCroppedImage() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);
    HapticFeedback.mediumImpact();

    try {
      final boundary = _cropBoundaryKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) {
        setState(() => _isSaving = false);
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 2.5);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        setState(() => _isSaving = false);
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();
      final outPath =
          '${Directory.systemTemp.path}/goal_crop_${DateTime.now().millisecondsSinceEpoch}.png';
      final outFile = File(outPath);
      await outFile.writeAsBytes(pngBytes, flush: true);

      if (mounted) {
        Navigator.pop(context, outFile.path);
      }
    } catch (_) {
      if (mounted) {
        Navigator.pop(context, widget.sourcePath);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.forestDeep,
      appBar: AppBar(
        backgroundColor: AppColors.forestDeep,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            LucideIcons.x,
            color: AppColors.baseWhite,
            size: context.w(22),
          ),
        ),
        title: Text(
          "Crop Goal Photo (1:1)",
          style: AppTextStyle.headingSmall(context).copyWith(
            color: AppColors.baseWhite,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveCroppedImage,
            child: Text(
              "Done",
              style: AppTextStyle.bodySemiBold(context).copyWith(
                color: AppColors.amberWarm,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(context.w(20)),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: context.borderRadius(all: 16),
                          child: RepaintBoundary(
                            key: _cropBoundaryKey,
                            child: Container(
                              color: Colors.black,
                              child: InteractiveViewer(
                                transformationController: _transformController,
                                minScale: 1.0,
                                maxScale: 4.0,
                                boundaryMargin: const EdgeInsets.all(120),
                                child: Center(
                                  child: RotatedBox(
                                    quarterTurns: _quarterTurns,
                                    child: Image.file(
                                      File(widget.sourcePath),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // 1:1 Crop Frame & Rule-of-Thirds Grid Overlay
                        IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: context.borderRadius(all: 16),
                              border: Border.all(
                                color: AppColors.emerald,
                                width: 2.5,
                              ),
                            ),
                            child: CustomPaint(
                              painter: _SquareCropGridPainter(
                                gridColor:
                                    AppColors.leafSoft.withValues(alpha: 0.45),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Bottom Controls Bar Matching App Theme
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(24),
                vertical: context.h(18),
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(context.r(20)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton.icon(
                    onPressed: _rotateRight,
                    icon: Icon(LucideIcons.rotateCw, size: context.w(16)),
                    label: const Text("Rotate"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.forestDeep,
                      side: BorderSide(color: AppColors.border),
                      shape: const StadiumBorder(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(12),
                      vertical: context.h(6),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.leafSoft,
                      borderRadius: context.borderRadius(all: 50),
                    ),
                    child: Text(
                      "1 : 1 Square",
                      style: AppTextStyle.captionSmall(context).copyWith(
                        color: AppColors.forestPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _resetTransform,
                    child: Text(
                      "Reset",
                      style: AppTextStyle.bodySemiBold(context).copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareCropGridPainter extends CustomPainter {
  final Color gridColor;

  _SquareCropGridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    final thirdW = size.width / 3;
    final thirdH = size.height / 3;

    // Vertical lines
    canvas.drawLine(Offset(thirdW, 0), Offset(thirdW, size.height), paint);
    canvas.drawLine(
      Offset(thirdW * 2, 0),
      Offset(thirdW * 2, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(Offset(0, thirdH), Offset(size.width, thirdH), paint);
    canvas.drawLine(
      Offset(0, thirdH * 2),
      Offset(size.width, thirdH * 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _SquareCropGridPainter oldDelegate) =>
      oldDelegate.gridColor != gridColor;
}
