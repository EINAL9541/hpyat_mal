import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hpyat_mal/core/extensions/context_extensions.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';
import 'package:hpyat_mal/core/theme/app_text_style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _selectedCameraIndex = 0;
  bool _isInitializing = true;
  bool _isTakingPicture = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCameras();
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) {
          setState(() {
            _isInitializing = false;
            _errorMessage = "No camera found on this device.";
          });
        }
        return;
      }
      await _setupCamera(_selectedCameraIndex);
    } catch (_) {
      // Fallback to native system camera if camera plugin channel isn't linked yet
      try {
        final XFile? fallbackFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
          maxWidth: 1440,
          maxHeight: 1440,
        );
        if (mounted) {
          Navigator.pop(context, fallbackFile?.path);
        }
      } catch (_) {
        if (mounted) {
          setState(() {
            _isInitializing = false;
            _errorMessage = "Unable to access camera.";
          });
        }
      }
    }
  }

  Future<void> _setupCamera(int index) async {
    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    final prevController = _controller;
    if (prevController != null) {
      await prevController.dispose();
    }

    final controller = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller = controller;

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {
          _selectedCameraIndex = index;
          _isInitializing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = "Camera permission denied or unavailable.";
        });
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _isInitializing || _isTakingPicture) return;
    HapticFeedback.selectionClick();
    final nextIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _setupCamera(nextIndex);
  }

  Future<void> _capturePhoto() async {
    final controller = _controller;
    if (controller == null ||
        !controller.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    setState(() => _isTakingPicture = true);
    HapticFeedback.mediumImpact();

    try {
      final XFile file = await controller.takePicture();
      if (mounted) {
        Navigator.pop(context, file.path);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
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
          "Take Goal Photo",
          style: AppTextStyle.headingSmall(context).copyWith(
            color: AppColors.baseWhite,
          ),
        ),
        actions: [
          if (_cameras.length > 1)
            IconButton(
              onPressed: _switchCamera,
              icon: Icon(
                LucideIcons.refreshCw,
                color: AppColors.baseWhite,
                size: context.w(20),
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
                  padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: context.borderRadius(all: 16),
                      child: Container(
                        color: Colors.black,
                        child: _buildCameraBody(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.w(24),
                vertical: context.h(28),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (_isInitializing ||
                            _errorMessage != null ||
                            _isTakingPicture)
                        ? null
                        : _capturePhoto,
                    child: Container(
                      width: context.w(74),
                      height: context.w(74),
                      padding: EdgeInsets.all(context.w(5)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.baseWhite,
                          width: 3,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: _isTakingPicture
                              ? AppColors.sageLight
                              : AppColors.emerald,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          LucideIcons.camera,
                          color: AppColors.baseWhite,
                          size: context.w(26),
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
    );
  }

  Widget _buildCameraBody(BuildContext context) {
    if (_isInitializing) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.emerald,
        ),
      );
    }

    if (_errorMessage != null ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.w(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                LucideIcons.cameraOff,
                color: AppColors.baseWhite.withValues(alpha: 0.7),
                size: context.w(36),
              ),
              SizedBox(height: context.h(12)),
              Text(
                _errorMessage ?? "Camera unavailable",
                textAlign: TextAlign.center,
                style: AppTextStyle.bodyMedium(context).copyWith(
                  color: AppColors.baseWhite,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _controller!.value.previewSize?.height ?? 1,
        height: _controller!.value.previewSize?.width ?? 1,
        child: CameraPreview(_controller!),
      ),
    );
  }
}
