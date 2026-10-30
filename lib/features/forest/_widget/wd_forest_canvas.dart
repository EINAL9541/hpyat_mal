import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hpyat_mal/core/theme/app_color.dart';

class ForestCanvasWidget extends StatefulWidget {
  final int days;
  final int vitality; // 0 - 100
  final PlantThemeType plantTheme;

  const ForestCanvasWidget({
    super.key,
    required this.days,
    required this.vitality,
    this.plantTheme = PlantThemeType.emerald,
  });

  @override
  State<ForestCanvasWidget> createState() => _ForestCanvasWidgetState();
}

class _BurstPetal {
  Offset position;
  Offset velocity;
  double size;
  double rotation;
  double rotationSpeed;
  double flipPhase;
  double life; // 0.0 -> 1.0
  Color color;
  bool isSparkle;

  _BurstPetal({
    required this.position,
    required this.velocity,
    required this.size,
    required this.rotation,
    required this.rotationSpeed,
    required this.flipPhase,
    required this.color,
    this.isSparkle = false,
  }) : life = 1.0;
}

class _ForestCanvasWidgetState extends State<ForestCanvasWidget>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _time = 0.0;
  Duration _lastElapsed = Duration.zero;
  double _windGust = 0.0;
  final List<_BurstPetal> _burstPetals = [];
  final math.Random _rng = math.Random();

  // Speed-up Growth Preview state
  bool _isSimulatingGrowth = false;
  double? _previewGrowthOverride; // 0.0 (Day 0 Sprout) -> 1.0 (Day 25+ Sanctuary)

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  double _daysToGrowth(int d) {
    if (d < 1) return 0.18;
    if (d < 4) return 0.42;
    if (d < 10) return 0.68;
    if (d < 21) return 0.88;
    return 1.0;
  }

  double get _effectiveGrowth =>
      _previewGrowthOverride ?? _daysToGrowth(widget.days);

  String _stageLabelForGrowth(double g) {
    final isCherry = widget.plantTheme.isCherry;
    if (g < 0.28) {
      return isCherry
          ? 'Stage 1 • Sakura Sprout (Day 0)'
          : 'Stage 1 • Emerald Sprout (Day 0)';
    }
    if (g < 0.52) {
      return isCherry
          ? 'Stage 2 • Cherry Sapling (Days 1–3)'
          : 'Stage 2 • Forest Sapling (Days 1–3)';
    }
    if (g < 0.76) {
      return isCherry
          ? 'Stage 3 • Blooming Sakura (Days 4–9)'
          : 'Stage 3 • Lush Canopy (Days 4–9)';
    }
    if (g < 0.93) {
      return isCherry
          ? 'Stage 4 • Imperial Sakura (Days 10–20)'
          : 'Stage 4 • Woodland Guardian (Days 10–20)';
    }
    return isCherry
        ? 'Stage 5 • Sacred Sakura (Day 21+)'
        : 'Stage 5 • Sacred Emerald (Day 21+)';
  }

  void _startSpeedUpGrowth() {
    setState(() {
      _isSimulatingGrowth = true;
      _previewGrowthOverride = 0.05;
      _windGust = 0.7;
    });
  }

  void _stopPreview() {
    setState(() {
      _isSimulatingGrowth = false;
      _previewGrowthOverride = null;
    });
  }

  void _onTick(Duration elapsed) {
    final dt = _lastElapsed == Duration.zero
        ? 0.016
        : (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    final clampedDt = dt.clamp(0.0, 0.05);
    _time += clampedDt;

    if (_isSimulatingGrowth && _previewGrowthOverride != null) {
      // Smoothly grow from 0.05 to 1.0 over ~7.5 seconds
      final prev = _previewGrowthOverride!;
      final next = (prev + clampedDt * 0.13).clamp(0.05, 1.0);
      _previewGrowthOverride = next;

      // Trigger celebratory blossom bursts as it crosses stage thresholds
      if ((prev < 0.30 && next >= 0.30) ||
          (prev < 0.55 && next >= 0.55) ||
          (prev < 0.80 && next >= 0.80) ||
          (prev < 0.98 && next >= 0.98)) {
        _windGust = 0.85;
      }

      if (next >= 1.0) {
        _isSimulatingGrowth = false;
      }
    }

    if (_windGust > 0.001) {
      _windGust *= math.pow(0.22, clampedDt).toDouble();
    } else {
      _windGust = 0.0;
    }

    for (int i = _burstPetals.length - 1; i >= 0; i--) {
      final p = _burstPetals[i];
      p.life -= clampedDt * (p.isSparkle ? 0.85 : 0.45);
      if (p.life <= 0) {
        _burstPetals.removeAt(i);
        continue;
      }
      final sway = math.sin(_time * 3.2 + p.flipPhase) * 18.0;
      p.position += Offset(
        (p.velocity.dx + sway) * clampedDt,
        p.velocity.dy * clampedDt,
      );
      p.velocity = Offset(
        p.velocity.dx * math.pow(0.92, clampedDt * 60).toDouble(),
        p.velocity.dy + (p.isSparkle ? -12.0 : 22.0) * clampedDt,
      );
      p.rotation += p.rotationSpeed * clampedDt;
    }

    setState(() {});
  }

  void _triggerBreeze(Offset localPos, Size size) {
    _windGust = 1.0;
    final origin = Offset(
      localPos.dx.clamp(size.width * 0.2, size.width * 0.8),
      localPos.dy.clamp(size.height * 0.18, size.height * 0.65),
    );

    final colors = widget.plantTheme.isCherry
        ? const [
            Color(0xFFFFB3C6),
            Color(0xFFFF8FAB),
            Color(0xFFFFE5EC),
            Color(0xFFFB6F92),
            Color(0xFFFFCCD5),
          ]
        : const [
            Color(0xFF52B788),
            Color(0xFF40916C),
            Color(0xFF74C69D),
            Color(0xFF95D5B2),
            Color(0xFFD8F3DC),
          ];

    for (int i = 0; i < 18; i++) {
      final angle = -math.pi * 0.75 + _rng.nextDouble() * math.pi * 1.1;
      final speed = 25.0 + _rng.nextDouble() * 65.0;
      _burstPetals.add(
        _BurstPetal(
          position: origin +
              Offset(
                (_rng.nextDouble() - 0.5) * 50,
                (_rng.nextDouble() - 0.5) * 36,
              ),
          velocity: Offset(
            math.cos(angle) * speed + 35.0,
            math.sin(angle) * speed - 10.0,
          ),
          size: 4.5 + _rng.nextDouble() * 4.5,
          rotation: _rng.nextDouble() * math.pi * 2,
          rotationSpeed: (_rng.nextDouble() - 0.5) * 5.0,
          flipPhase: _rng.nextDouble() * math.pi * 2,
          color: colors[_rng.nextInt(colors.length)],
        ),
      );
    }

    for (int i = 0; i < 8; i++) {
      _burstPetals.add(
        _BurstPetal(
          position: origin +
              Offset(
                (_rng.nextDouble() - 0.5) * 70,
                (_rng.nextDouble() - 0.5) * 50,
              ),
          velocity: Offset(
            (_rng.nextDouble() - 0.5) * 30,
            -15.0 - _rng.nextDouble() * 25.0,
          ),
          size: 2.2 + _rng.nextDouble() * 2.2,
          rotation: 0,
          rotationSpeed: 0,
          flipPhase: _rng.nextDouble() * math.pi * 2,
          color: const Color(0xFFFFF3B0),
          isSparkle: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final growth = _effectiveGrowth;
    final isCherry = widget.plantTheme.isCherry;
    final accentColor = AppColors.emerald;
    final borderColor = AppColors.border;
    final deepTextColor = AppColors.forestDeep;

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasSize = Size(constraints.maxWidth, 275);
        return GestureDetector(
          onTapDown: (details) =>
              _triggerBreeze(details.localPosition, canvasSize),
          onLongPress: _startSpeedUpGrowth,
          child: Container(
            height: 275,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.cardShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  CustomPaint(
                    size: canvasSize,
                    painter: _SakuraTreePainter(
                      growth: growth,
                      vitality: widget.vitality,
                      time: _time,
                      windGust: _windGust,
                      burstPetals: _burstPetals,
                      isCherry: isCherry,
                    ),
                  ),

                  // Growth Preview Overlay Controls (only visible when long-press preview is active)
                  if (_previewGrowthOverride != null)
                    Positioned(
                      left: 12,
                      top: 12,
                      right: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceCard.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(
                                color: accentColor,
                              ),
                            ),
                            child: Text(
                              _stageLabelForGrowth(growth),
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: deepTextColor,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _stopPreview,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.forestDeep,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Text(
                                "✕ Exit Preview",
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Subtle interactive hint pill
                  if (_previewGrowthOverride == null)
                    Positioned(
                      right: 12,
                      bottom: 10,
                      child: IgnorePointer(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceCard.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: borderColor.withValues(alpha: 0.6),
                            ),
                          ),
                          child: Text(
                            isCherry
                                ? "Tap for Sakura Breeze • Hold to preview growth"
                                : "Tap for Forest Breeze • Hold to preview growth",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: deepTextColor,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SakuraTreePainter extends CustomPainter {
  final double growth; // 0.05 -> 1.0
  final int vitality;
  final double time;
  final double windGust;
  final List<_BurstPetal> burstPetals;
  final bool isCherry;

  _SakuraTreePainter({
    required this.growth,
    required this.vitality,
    required this.time,
    required this.windGust,
    required this.burstPetals,
    required this.isCherry,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final vitalityFactor = (vitality / 100.0).clamp(0.25, 1.0);

    // 1. Dreamy Dawn Sky Gradient (Sakura Dawn vs Crisp Emerald Morning)
    final skyPaint = Paint()
      ..shader = LinearGradient(
        colors: isCherry
            ? const [
                Color(0xFFE8F3FA), // Soft morning zenith blue
                Color(0xFFFDF0F5), // Warm sakura mist
                Color(0xFFFFE5EC), // Soft blush horizon
                Color(0xFFFFF3E6), // Golden morning glow near hills
              ]
            : const [
                Color(0xFFDDF2EB), // Crisp mountain morning sky
                Color(0xFFEAF7F1), // Soft sunlit mist
                Color(0xFFD8F3DC), // Fresh valley horizon
                Color(0xFFFFF8E7), // Warm golden sunbeam glow
              ],
        stops: const [0.0, 0.42, 0.75, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    // 2. Radiant Morning Sun & Rotating Crepuscular Light Rays
    _drawSunAndRays(canvas, size);

    // 3. Soft Drifting Spring Clouds
    _drawDriftingClouds(canvas, size);

    // 4. Distant Misty Mountain Silhouettes (Serene Sanctuary Horizon)
    _drawMistyMountains(canvas, size);

    // 5. Background Falling Petals (far depth)
    _drawAmbientPetals(canvas, size, isForeground: false);

    // 6. Rolling Lush Hills, Stream Reflection & Fallen Petals
    _drawHillsAndStream(canvas, size, vitalityFactor);

    // 7. Sculpted Cherry Blossom Tree (Sakura) with continuous growth animation
    final baseCenterX = size.width * 0.5;
    final baseCenterY = size.height * 0.855;
    final sway = (math.sin(time * 1.35) * 0.032) +
        (math.sin(time * 2.7) * 0.012) +
        (math.sin(time * 6.0) * 0.045 * windGust) +
        (0.055 * windGust);

    _drawSakuraTree(
      canvas,
      size,
      baseCenterX,
      baseCenterY,
      sway,
      vitalityFactor,
      growth,
    );

    // 8. Foreground Swaying Grass & Fallen Petals around Trunk Roots
    _drawForegroundDetails(canvas, size, baseCenterX, baseCenterY, sway);

    // 9. Foreground Falling Sakura Petals & Golden Dewdrop Fireflies
    _drawAmbientPetals(canvas, size, isForeground: true);
    _drawGoldenDewdrops(canvas, size);

    // 10. Interactive Burst Petals & Sparkles
    _drawBurstParticles(canvas);

    // 11. Subtle Inner Frame Highlight
    final borderPaint = Paint()
      ..color = (isCherry
              ? const Color(0xFFFFCCD5)
              : const Color(0xFF74C69D))
          .withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(0.75), const Radius.circular(28)),
      borderPaint,
    );

    // 12. Recovery Mist Overlay when vitality is low
    if (vitality < 80) {
      final fogOpacity = ((80 - vitality) / 80.0) * 0.32;
      final fogPaint = Paint()
        ..color = const Color(0xFF9BA8A2).withValues(alpha: fogOpacity);
      canvas.drawRect(rect, fogPaint);
    }
  }

  void _drawSunAndRays(Canvas canvas, Size size) {
    final sunCenter = Offset(
      size.width * 0.76,
      size.height * 0.24 + math.sin(time * 0.8) * 3.0,
    );
    final pulse = 1.0 + math.sin(time * 1.6) * 0.08;

    // Soft rotating sunbeams
    canvas.save();
    canvas.translate(sunCenter.dx, sunCenter.dy);
    canvas.rotate(time * 0.06);
    final rayPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFF3B0).withValues(alpha: 0.28),
          const Color(0xFFFFCCD5).withValues(alpha: 0.10),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 150));

    for (int i = 0; i < 8; i++) {
      canvas.save();
      canvas.rotate(i * math.pi / 4);
      final rayPath = Path()
        ..moveTo(0, 0)
        ..lineTo(-18, -145)
        ..lineTo(18, -145)
        ..close();
      canvas.drawPath(rayPath, rayPaint);
      canvas.restore();
    }
    canvas.restore();

    // Outer warm halo
    final outerGlow = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFE5B4).withValues(alpha: 0.55),
          const Color(0xFFFFB3C6).withValues(alpha: 0.18),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: 85 * pulse));
    canvas.drawCircle(sunCenter, 85 * pulse, outerGlow);

    // Sun disc
    final sunDisc = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFFFFFFF),
          const Color(0xFFFFF3C4),
          const Color(0xFFFFD166).withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: sunCenter, radius: 26 * pulse));
    canvas.drawCircle(sunCenter, 26 * pulse, sunDisc);
  }

  void _drawDriftingClouds(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.62)
      ..style = PaintingStyle.fill;

    final c1x = ((size.width * 0.18 + time * 4.5) % (size.width + 120)) - 60;
    final c2x = ((size.width * 0.68 + time * 3.0) % (size.width + 120)) - 60;

    _drawSingleCloud(canvas, Offset(c1x, size.height * 0.19), 0.85, cloudPaint);
    _drawSingleCloud(canvas, Offset(c2x, size.height * 0.13), 0.65, cloudPaint);
  }

  void _drawSingleCloud(
    Canvas canvas,
    Offset center,
    double scale,
    Paint paint,
  ) {
    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: center,
          width: 58 * scale,
          height: 18 * scale,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(-12 * scale, -5 * scale),
          radius: 12 * scale,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(6 * scale, -7 * scale),
          radius: 14 * scale,
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: center + Offset(18 * scale, -2 * scale),
          radius: 10 * scale,
        ),
      );
    canvas.drawPath(path, paint);
  }

  void _drawMistyMountains(Canvas canvas, Size size) {
    final farMountainPaint = Paint()
      ..shader = LinearGradient(
        colors: isCherry
            ? [
                const Color(0xFFD8C2D8).withValues(alpha: 0.38),
                const Color(0xFFF3D5E5).withValues(alpha: 0.12),
              ]
            : [
                const Color(0xFF95B8A6).withValues(alpha: 0.36),
                const Color(0xFFD8F3DC).withValues(alpha: 0.14),
              ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, size.height * 0.45, size.width, size.height * 0.4),
      );

    final farPath = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.18,
        size.height * 0.56,
        size.width * 0.38,
        size.height * 0.72,
      )
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.50,
        size.width * 0.88,
        size.height * 0.68,
      )
      ..lineTo(size.width, size.height * 0.64)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(farPath, farMountainPaint);
  }

  void _drawHillsAndStream(Canvas canvas, Size size, double vitalityFactor) {
    final hillBackPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(
            const Color(0xFF95B8A6),
            const Color(0xFF74C69D),
            vitalityFactor,
          )!,
          Color.lerp(
            const Color(0xFF6B9080),
            const Color(0xFF40916C),
            vitalityFactor,
          )!,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(0, size.height * 0.70, size.width, size.height * 0.3),
      );

    final hillBack = Path()
      ..moveTo(0, size.height * 0.79)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.71,
        size.width * 0.62,
        size.height * 0.84,
        size.width,
        size.height * 0.75,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillBack, hillBackPaint);

    // Serene reflective stream winding at the right-bottom
    final streamPaint = Paint()
      ..shader = LinearGradient(
        colors: isCherry
            ? const [
                Color(0xFFBDE0FE),
                Color(0xFFFFCCD5),
                Color(0xFFA2D2FF),
              ]
            : const [
                Color(0xFFBDE0FE),
                Color(0xFFD8F3DC),
                Color(0xFF90CAF9),
              ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(
        Rect.fromLTWH(
          size.width * 0.5,
          size.height * 0.78,
          size.width * 0.5,
          size.height * 0.22,
        ),
      );

    final streamPath = Path()
      ..moveTo(size.width * 0.58, size.height * 0.82)
      ..quadraticBezierTo(
        size.width * 0.76,
        size.height * 0.84,
        size.width,
        size.height * 0.80,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(size.width * 0.45, size.height)
      ..close();
    canvas.drawPath(streamPath, streamPaint);

    // Animated water ripples on stream
    final ripplePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      final shift = math.sin(time * 2.0 + i * 1.4) * 4.0;
      final rx = size.width * (0.68 + i * 0.065) + shift;
      final ry = size.height * (0.855 + i * 0.025);
      canvas.drawLine(Offset(rx - 8, ry), Offset(rx + 8, ry), ripplePaint);
    }

    // Foreground sanctuary mound where the tree stands
    final hillFrontPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Color.lerp(
            const Color(0xFF5A7D6C),
            const Color(0xFF40916C),
            vitalityFactor,
          )!,
          Color.lerp(
            const Color(0xFF2D4A3E),
            const Color(0xFF1B4D3E),
            vitalityFactor,
          )!,
          const Color(0xFF0F291E),
        ],
        stops: const [0.0, 0.55, 1.0],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(
        Rect.fromLTWH(0, size.height * 0.77, size.width, size.height * 0.23),
      );

    final hillFront = Path()
      ..moveTo(0, size.height * 0.87)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.77,
        size.width * 0.65,
        size.height * 0.79,
        size.width * 0.88,
        size.height,
      )
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillFront, hillFrontPaint);

    // Fallen petals or sunlit emerald leaves scattered across the grassy mound
    final fallenColors = isCherry
        ? const [
            Color(0xFFFFB3C6),
            Color(0xFFFF8FAB),
            Color(0xFFFFE5EC),
            Color(0xFFFB6F92),
          ]
        : const [
            Color(0xFF74C69D),
            Color(0xFF52B788),
            Color(0xFFD8F3DC),
            Color(0xFF95D5B2),
          ];

    final petalCount = (6 + (growth * 18).round()).clamp(4, 24);
    for (int i = 0; i < petalCount; i++) {
      final seed = i * 37.3;
      final px = size.width * (0.14 + ((seed * 13) % 68) / 100.0);
      final py = size.height * (0.835 + ((seed * 29) % 14) / 100.0);
      final pPaint = Paint()
        ..color = fallenColors[i % fallenColors.length].withValues(alpha: 0.78);
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate((i * 0.7));
      canvas.drawOval(
        Rect.fromCenter(center: Offset.zero, width: 5.5, height: 2.6),
        pPaint,
      );
      canvas.restore();
    }
  }

  void _drawSakuraTree(
    Canvas canvas,
    Size size,
    double baseX,
    double baseY,
    double sway,
    double vitalityFactor,
    double g,
  ) {
    // Smooth overall tree scale from tender shoot (0.46) to majestic ancient tree (1.04)
    final stageScale = 0.46 + (g * 0.58);

    canvas.save();
    canvas.translate(baseX, baseY);
    canvas.scale(stageScale);

    // Shadow beneath the trunk on the grass
    final shadowPaint = Paint()
      ..color = const Color(0xFF0F291E).withValues(alpha: 0.35);
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(0, 3),
        width: 45 + 35 * g,
        height: 12 + 3 * g,
      ),
      shadowPaint,
    );

    final barkDark = Color.lerp(
      const Color(0xFF4A3B39),
      isCherry ? const Color(0xFF4A2525) : const Color(0xFF3E2A1E),
      vitalityFactor,
    )!;
    final barkMid = Color.lerp(
      const Color(0xFF63514F),
      isCherry ? const Color(0xFF6B3834) : const Color(0xFF5C4033),
      vitalityFactor,
    )!;
    final barkHighlight = Color.lerp(
      const Color(0xFF84706D),
      isCherry ? const Color(0xFF9C594F) : const Color(0xFF85604C),
      vitalityFactor,
    )!;

    final swayPx = sway * 120.0;

    // --- 1. Sculpted Organic Trunk & Root Flares ---
    final trunkPaint = Paint()
      ..shader = LinearGradient(
        colors: [barkDark, barkMid, barkHighlight],
        stops: const [0.0, 0.65, 1.0],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(const Rect.fromLTWH(-35, -135, 70, 145));

    final trunkPath = Path()
      ..moveTo(-26, 6)
      ..quadraticBezierTo(-14, 0, -11, -18)
      ..cubicTo(-9, -46, -15 + swayPx * 0.25, -72, -8 + swayPx * 0.5, -98)
      ..lineTo(8 + swayPx * 0.5, -98)
      ..cubicTo(12 + swayPx * 0.25, -70, 8, -42, 12, -16)
      ..quadraticBezierTo(16, 1, 28, 6)
      ..quadraticBezierTo(10, 4, 0, 5)
      ..quadraticBezierTo(-12, 4, -26, 6)
      ..close();
    canvas.drawPath(trunkPath, trunkPaint);

    // --- 2. Graceful Sweeping Boughs (extend outward with growth) ---
    final reach = (0.55 + g * 0.45).clamp(0.5, 1.0);

    // Left sweeping lower bough
    _drawTaperedBranch(
      canvas,
      start: Offset(-6 + swayPx * 0.3, -64),
      control1: Offset(-32 * reach + swayPx * 0.5, -72),
      control2: Offset(-58 * reach + swayPx * 0.8, -82),
      end: Offset(-82 * reach + swayPx * 1.1, -92),
      startWidth: 10.5,
      endWidth: 2.5,
      color: barkDark,
      highlightColor: barkHighlight,
    );

    // Left-mid ascending bough
    _drawTaperedBranch(
      canvas,
      start: Offset(-5 + swayPx * 0.45, -88),
      control1: Offset(-22 * reach + swayPx * 0.7, -108),
      control2: Offset(-42 * reach + swayPx * 0.95, -124),
      end: Offset(-58 * reach + swayPx * 1.25, -136),
      startWidth: 9.0,
      endWidth: 2.2,
      color: barkDark,
      highlightColor: barkHighlight,
    );

    // Right sweeping panoramic bough
    _drawTaperedBranch(
      canvas,
      start: Offset(6 + swayPx * 0.35, -70),
      control1: Offset(34 * reach + swayPx * 0.6, -78),
      control2: Offset(62 * reach + swayPx * 0.9, -90),
      end: Offset(86 * reach + swayPx * 1.15, -102),
      startWidth: 10.5,
      endWidth: 2.5,
      color: barkMid,
      highlightColor: barkHighlight,
    );

    // Right-mid ascending bough
    _drawTaperedBranch(
      canvas,
      start: Offset(5 + swayPx * 0.48, -92),
      control1: Offset(22 * reach + swayPx * 0.75, -112),
      control2: Offset(38 * reach + swayPx * 1.0, -128),
      end: Offset(52 * reach + swayPx * 1.25, -142),
      startWidth: 8.5,
      endWidth: 2.2,
      color: barkMid,
      highlightColor: barkHighlight,
    );

    // Center crown bough
    _drawTaperedBranch(
      canvas,
      start: Offset(swayPx * 0.5, -94),
      control1: Offset(-6 + swayPx * 0.8, -118),
      control2: Offset(4 + swayPx * 1.1, -138),
      end: Offset(swayPx * 1.35, -156 * reach),
      startWidth: 8.5,
      endWidth: 2.0,
      color: barkMid,
      highlightColor: barkHighlight,
    );

    // Characteristic bark texture lines on the trunk
    final lenticelPaint = Paint()
      ..color = barkHighlight.withValues(alpha: 0.55)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 6; i++) {
      final ly = -18.0 - i * 12.0;
      final lx = (i.isEven ? -3.0 : 2.0) + swayPx * (i * 0.05);
      canvas.drawLine(Offset(lx - 4, ly), Offset(lx + 4, ly), lenticelPaint);
    }

    // --- 3. Lush Multi-Layered Canopy Clouds (Sakura Pink vs Emerald Foliage) ---
    final deepCanopy = isCherry
        ? Color.lerp(
            const Color(0xFFB5838D),
            const Color(0xFFD84B78),
            vitalityFactor,
          )!
        : Color.lerp(
            const Color(0xFF3A5A49),
            const Color(0xFF1B4D3E),
            vitalityFactor,
          )!;
    final midCanopy = isCherry
        ? Color.lerp(
            const Color(0xFFDDBEA9),
            const Color(0xFFFF85A1),
            vitalityFactor,
          )!
        : Color.lerp(
            const Color(0xFF5A826E),
            const Color(0xFF2D6A4F),
            vitalityFactor,
          )!;
    final softCanopy = isCherry
        ? Color.lerp(
            const Color(0xFFEDE0D4),
            const Color(0xFFFFB3C6),
            vitalityFactor,
          )!
        : Color.lerp(
            const Color(0xFF7FA993),
            const Color(0xFF52B788),
            vitalityFactor,
          )!;
    final sunlitHighlight = isCherry
        ? Color.lerp(
            const Color(0xFFF8F4F1),
            const Color(0xFFFFF0F5),
            vitalityFactor,
          )!
        : Color.lerp(
            const Color(0xFFB8D4C4),
            const Color(0xFFB7E4C7),
            vitalityFactor,
          )!;

    // Each cluster has an unlock threshold so during speed-up test you watch buds pop & bloom!
    final allClusters = <_SakuraCluster>[
      // Core heart clusters (present from Sprout / Stage 1)
      _SakuraCluster(Offset(-22 * reach + swayPx * 0.85, -108), 38, 0.7, 0.0),
      _SakuraCluster(Offset(24 * reach + swayPx * 0.9, -112), 38, 1.8, 0.0),
      _SakuraCluster(Offset(swayPx * 1.35, -150 * reach), 40, 4.5, 0.05),
      // Stage 2 Sapling clusters
      _SakuraCluster(Offset(-52 * reach + swayPx * 1.0, -124), 36, 2.1, 0.22),
      _SakuraCluster(Offset(54 * reach + swayPx * 1.05, -128), 36, 3.3, 0.26),
      _SakuraCluster(Offset(-78 * reach + swayPx * 1.1, -94), 30, 0.0, 0.32),
      _SakuraCluster(Offset(82 * reach + swayPx * 1.15, -104), 32, 1.2, 0.36),
      // Stage 3 Blooming clusters
      _SakuraCluster(Offset(-26 * reach + swayPx * 1.2, -144), 36, 2.7, 0.48),
      _SakuraCluster(Offset(26 * reach + swayPx * 1.2, -146), 36, 3.9, 0.52),
      _SakuraCluster(Offset(-96 * reach + swayPx * 1.25, -80), 25, 5.1, 0.60),
      _SakuraCluster(Offset(98 * reach + swayPx * 1.25, -90), 26, 0.4, 0.64),
      // Stage 4 & 5 Sanctuary crown clusters
      _SakuraCluster(Offset(-66 * reach + swayPx * 1.3, -148), 29, 1.5, 0.74),
      _SakuraCluster(Offset(68 * reach + swayPx * 1.3, -150), 29, 2.9, 0.78),
      _SakuraCluster(Offset(swayPx * 1.45, -172), 32, 3.6, 0.86),
    ];

    // Pass 1: Deep under-canopy shadows for 3D depth
    for (final c in allClusters) {
      final bloom = ((g - c.minGrowth) / 0.18).clamp(0.0, 1.0);
      if (bloom <= 0) continue;
      final easeBloom = Curves.easeOutBack.transform(bloom);
      final breathe = 1.0 + math.sin(time * 1.8 + c.phase) * 0.035;
      _drawScallopedBlossomCloud(
        canvas,
        c.center + const Offset(0, 6),
        c.radius * breathe * easeBloom,
        deepCanopy.withValues(alpha: 0.88),
        c.phase,
      );
    }

    // Subtle peeking branches inside the canopy for realism
    final twigPaint = Paint()
      ..color = barkDark.withValues(alpha: 0.75)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(-20 * reach + swayPx * 0.7, -96),
      Offset(-42 * reach + swayPx * 0.95, -112),
      twigPaint,
    );
    canvas.drawLine(
      Offset(18 * reach + swayPx * 0.7, -98),
      Offset(40 * reach + swayPx * 0.95, -116),
      twigPaint,
    );

    // Pass 2: Vibrant main body
    for (final c in allClusters) {
      final bloom = ((g - c.minGrowth) / 0.18).clamp(0.0, 1.0);
      if (bloom <= 0) continue;
      final easeBloom = Curves.easeOutBack.transform(bloom);
      final breathe = 1.0 + math.sin(time * 1.8 + c.phase + 0.5) * 0.04;
      _drawScallopedBlossomCloud(
        canvas,
        c.center,
        c.radius * 0.92 * breathe * easeBloom,
        midCanopy,
        c.phase + 1.0,
      );
    }

    // Pass 3: Soft upper puffs
    for (final c in allClusters) {
      final bloom = ((g - c.minGrowth) / 0.18).clamp(0.0, 1.0);
      if (bloom <= 0) continue;
      final easeBloom = Curves.easeOutBack.transform(bloom);
      final breathe = 1.0 + math.sin(time * 2.1 + c.phase + 1.1) * 0.04;
      _drawScallopedBlossomCloud(
        canvas,
        c.center + const Offset(2, -5),
        c.radius * 0.74 * breathe * easeBloom,
        softCanopy,
        c.phase + 2.2,
      );
    }

    // Pass 4: Sunlit highlights on top-right of each cluster
    for (final c in allClusters) {
      final bloom = ((g - c.minGrowth) / 0.18).clamp(0.0, 1.0);
      if (bloom <= 0) continue;
      final easeBloom = Curves.easeOutBack.transform(bloom);
      _drawScallopedBlossomCloud(
        canvas,
        c.center + const Offset(5, -9),
        c.radius * 0.46 * easeBloom,
        sunlitHighlight.withValues(alpha: 0.92),
        c.phase + 3.4,
      );
    }

    // --- 4. Detailed Flowers (Cherry) or Sunlit Leaf Sprigs (Emerald) Across the Canopy ---
    final flowerOffsets = <Offset>[
      Offset(-26 * reach + swayPx * 0.9, -114),
      Offset(4 * reach + swayPx * 0.95, -126),
      Offset(32 * reach + swayPx * 0.9, -108),
      Offset(2 + swayPx * 1.35, -154 * reach),
      Offset(-38 * reach + swayPx * 0.85, -88),
      Offset(44 * reach + swayPx * 0.85, -92),
      Offset(-64 * reach + swayPx * 1.05, -104),
      Offset(-48 * reach + swayPx * 1.1, -130),
      Offset(56 * reach + swayPx * 1.1, -132),
      Offset(78 * reach + swayPx * 1.15, -102),
      Offset(-82 * reach + swayPx * 1.1, -92),
      Offset(-18 * reach + swayPx * 1.25, -152),
      Offset(28 * reach + swayPx * 1.2, -148),
      Offset(-96 * reach + swayPx * 1.25, -80),
      Offset(96 * reach + swayPx * 1.25, -88),
      Offset(-10 * reach + swayPx * 1.1, -140),
      Offset(16 * reach + swayPx * 1.1, -138),
      Offset(-68 * reach + swayPx * 1.3, -148),
      Offset(66 * reach + swayPx * 1.3, -150),
      Offset(swayPx * 1.45, -176),
    ];

    final activeFlowers =
        (4 + (g * (flowerOffsets.length - 4)).round()).clamp(4, flowerOffsets.length);

    for (int i = 0; i < activeFlowers; i++) {
      final fPos = flowerOffsets[i];
      final fScale = (i % 3 == 0) ? 7.5 : ((i % 2 == 0) ? 6.2 : 5.2);
      final fRot = time * 0.35 * (i.isEven ? 1 : -1) + i * 0.8;
      if (isCherry) {
        final petalCol = i % 3 == 0
            ? sunlitHighlight
            : (i.isEven ? const Color(0xFFFFCCD5) : softCanopy);
        _drawDetailedSakuraFlower(
          canvas,
          fPos,
          fScale,
          fRot,
          petalCol,
          deepCanopy,
        );
      } else {
        final leafCol = i % 3 == 0
            ? const Color(0xFFD8F3DC)
            : (i.isEven ? const Color(0xFF95D5B2) : const Color(0xFF74C69D));
        _drawSunlitLeafSprig(
          canvas,
          fPos,
          fScale,
          fRot * 0.3,
          leafCol,
        );
      }
    }

    canvas.restore();
  }

  void _drawSunlitLeafSprig(
    Canvas canvas,
    Offset center,
    double radius,
    double rotation,
    Color leafColor,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);
    final paint = Paint()
      ..color = leafColor
      ..style = PaintingStyle.fill;

    // Pair of graceful botanical leaves + sunlit dew bud
    for (final angle in [-0.45, 0.45]) {
      canvas.save();
      canvas.rotate(angle);
      final leaf = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(
          -radius * 0.45,
          -radius * 0.55,
          0,
          -radius * 1.05,
        )
        ..quadraticBezierTo(
          radius * 0.45,
          -radius * 0.55,
          0,
          0,
        )
        ..close();
      canvas.drawPath(leaf, paint);
      canvas.restore();
    }
    canvas.drawCircle(
      Offset(0, -radius * 0.2),
      radius * 0.16,
      Paint()..color = const Color(0xFFFFF3B0),
    );
    canvas.restore();
  }

  void _drawTaperedBranch(
    Canvas canvas, {
    required Offset start,
    required Offset control1,
    required Offset control2,
    required Offset end,
    required double startWidth,
    required double endWidth,
    required Color color,
    required Color highlightColor,
  }) {
    final normalStart = Offset(0, -startWidth * 0.5);
    final normalEnd = Offset(0, -endWidth * 0.5);

    final path = Path()
      ..moveTo(start.dx + normalStart.dx, start.dy + normalStart.dy)
      ..cubicTo(
        control1.dx,
        control1.dy - startWidth * 0.35,
        control2.dx,
        control2.dy - endWidth * 0.4,
        end.dx + normalEnd.dx,
        end.dy + normalEnd.dy,
      )
      ..lineTo(end.dx - normalEnd.dx, end.dy - normalEnd.dy)
      ..cubicTo(
        control2.dx,
        control2.dy + endWidth * 0.4,
        control1.dx,
        control1.dy + startWidth * 0.35,
        start.dx - normalStart.dx,
        start.dy - normalStart.dy,
      )
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    // Subtle sunlit top edge highlight
    final highlightPath = Path()
      ..moveTo(start.dx, start.dy - startWidth * 0.35)
      ..cubicTo(
        control1.dx,
        control1.dy - startWidth * 0.3,
        control2.dx,
        control2.dy - endWidth * 0.3,
        end.dx,
        end.dy - endWidth * 0.3,
      );
    canvas.drawPath(
      highlightPath,
      Paint()
        ..color = highlightColor.withValues(alpha: 0.45)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  void _drawScallopedBlossomCloud(
    Canvas canvas,
    Offset center,
    double radius,
    Color color,
    double seed,
  ) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2.1,
        height: radius * 1.55,
      ),
      paint,
    );

    const puffCount = 6;
    for (int i = 0; i < puffCount; i++) {
      final angle = (i / puffCount) * math.pi * 2 + seed * 0.3;
      final dist = radius * 0.58;
      final px = center.dx + math.cos(angle) * dist * 1.15;
      final py = center.dy + math.sin(angle) * dist * 0.82;
      final puffR = radius * (0.52 + (i % 2) * 0.10);
      canvas.drawCircle(Offset(px, py), puffR, paint);
    }
  }

  void _drawDetailedSakuraFlower(
    Canvas canvas,
    Offset center,
    double radius,
    double rotation,
    Color petalColor,
    Color coreColor,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final petalPaint = Paint()
      ..color = petalColor
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      canvas.save();
      canvas.rotate(i * (math.pi * 2 / 5));

      final petalPath = Path()
        ..moveTo(0, 0)
        ..quadraticBezierTo(
          -radius * 0.55,
          -radius * 0.55,
          -radius * 0.22,
          -radius,
        )
        ..lineTo(0, -radius * 0.78)
        ..lineTo(radius * 0.22, -radius)
        ..quadraticBezierTo(radius * 0.55, -radius * 0.55, 0, 0)
        ..close();

      canvas.drawPath(petalPath, petalPaint);
      canvas.restore();
    }

    canvas.drawCircle(
      Offset.zero,
      radius * 0.24,
      Paint()..color = coreColor,
    );
    canvas.drawCircle(
      Offset.zero,
      radius * 0.12,
      Paint()..color = const Color(0xFFFFD166),
    );

    canvas.restore();
  }

  void _drawForegroundDetails(
    Canvas canvas,
    Size size,
    double baseX,
    double baseY,
    double sway,
  ) {
    final grassPaint = Paint()
      ..color = const Color(0xFF52B788)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final grassPositions = [-36.0, -24.0, -16.0, 18.0, 28.0, 42.0];
    for (int i = 0; i < grassPositions.length; i++) {
      final gx = baseX + grassPositions[i];
      final gy = baseY + 4 + (i % 2) * 3;
      final bladeSway = sway * 95 + (i.isEven ? 3.0 : -2.0);
      final path = Path()
        ..moveTo(gx, gy)
        ..quadraticBezierTo(
          gx + bladeSway * 0.5,
          gy - 8,
          gx + bladeSway,
          gy - 14,
        );
      canvas.drawPath(path, grassPaint);
    }
  }

  void _drawAmbientPetals(
    Canvas canvas,
    Size size, {
    required bool isForeground,
  }) {
    final baseCount = isForeground ? 16 : 12;
    final count = (baseCount * (0.45 + 0.55 * growth)).round();
    final colors = isCherry
        ? const [
            Color(0xFFFFB3C6),
            Color(0xFFFF8FAB),
            Color(0xFFFFE5EC),
            Color(0xFFFFCCD5),
          ]
        : const [
            Color(0xFF74C69D),
            Color(0xFF52B788),
            Color(0xFFD8F3DC),
            Color(0xFF95D5B2),
          ];

    for (int i = 0; i < count; i++) {
      final seed = i * 19.7 + (isForeground ? 0.0 : 100.0);
      final speedY =
          isForeground ? (14.0 + (i % 4) * 3.5) : (9.0 + (i % 3) * 2.5);
      final speedX =
          isForeground ? (18.0 + (i % 3) * 4.0) : (12.0 + (i % 3) * 2.5);

      final rawY = (seed * 13.0 + time * speedY) % (size.height + 30) - 15;
      final waveX = math.sin(time * 1.6 + seed) * (isForeground ? 16.0 : 10.0);
      final rawX =
          (seed * 47.0 + time * speedX + waveX) % (size.width + 40) - 20;

      final petalRadius =
          isForeground ? (4.2 + (i % 3) * 1.3) : (2.6 + (i % 2) * 1.0);
      final rot = time * (1.2 + (i % 3) * 0.4) + seed;
      final flip = 0.45 + 0.55 * math.cos(time * 2.4 + seed).abs();

      final paint = Paint()
        ..color = colors[i % colors.length].withValues(
          alpha: isForeground ? 0.88 : 0.55,
        );

      _drawSingleNotchedPetal(
        canvas,
        Offset(rawX, rawY),
        petalRadius,
        rot,
        flip,
        paint,
      );
    }
  }

  void _drawSingleNotchedPetal(
    Canvas canvas,
    Offset pos,
    double radius,
    double rotation,
    double flipScaleY,
    Paint paint,
  ) {
    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    canvas.rotate(rotation);
    canvas.scale(1.0, flipScaleY);

    final path = Path()
      ..moveTo(0, radius)
      ..quadraticBezierTo(-radius * 0.85, 0, -radius * 0.32, -radius)
      ..lineTo(0, -radius * 0.65)
      ..lineTo(radius * 0.32, -radius)
      ..quadraticBezierTo(radius * 0.85, 0, 0, radius)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  void _drawGoldenDewdrops(Canvas canvas, Size size) {
    for (int i = 0; i < 7; i++) {
      final phase = i * 1.35;
      final px = size.width * (0.18 + i * 0.11) +
          math.cos(time * 1.1 + phase) * 8.0;
      final py = size.height * (0.36 + (i % 3) * 0.14) +
          math.sin(time * 1.7 + phase) * 10.0;
      final alpha = (0.35 + 0.55 * (0.5 + 0.5 * math.sin(time * 2.6 + phase)))
          .clamp(0.1, 0.9);

      final glowPaint = Paint()
        ..color = const Color(0xFFFFF3B0).withValues(alpha: alpha * 0.45);
      final corePaint = Paint()
        ..color = Colors.white.withValues(alpha: alpha);

      canvas.drawCircle(Offset(px, py), 4.5, glowPaint);
      canvas.drawCircle(Offset(px, py), 1.8, corePaint);
    }
  }

  void _drawBurstParticles(Canvas canvas) {
    for (final p in burstPetals) {
      final alpha = p.life.clamp(0.0, 1.0);
      final paint = Paint()..color = p.color.withValues(alpha: alpha);

      if (p.isSparkle) {
        canvas.drawCircle(
          p.position,
          p.size * 1.8,
          Paint()..color = p.color.withValues(alpha: alpha * 0.35),
        );
        canvas.drawCircle(p.position, p.size * 0.8, paint);
      } else {
        final flip = 0.4 + 0.6 * math.sin(time * 4.5 + p.flipPhase).abs();
        _drawSingleNotchedPetal(
          canvas,
          p.position,
          p.size,
          p.rotation,
          flip,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SakuraTreePainter oldDelegate) => true;
}

class _SakuraCluster {
  final Offset center;
  final double radius;
  final double phase;
  final double minGrowth;

  const _SakuraCluster(this.center, this.radius, this.phase, this.minGrowth);
}
