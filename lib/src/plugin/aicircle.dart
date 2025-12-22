import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AICircleWidget extends StatefulWidget {
  const AICircleWidget({super.key});

  @override
  State<AICircleWidget> createState() => _AICircleWidgetState();
}

class _AICircleWidgetState extends State<AICircleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ColorBlob> _colorBlobs = [];
  bool _isAnimating = true;
  double _speed = 1.0;
  double _blurLevel = 8.0;
  double _time = 0;
  final double _circleRadius = 140;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(() {
        setState(() {
          _time += 0.1;
          if (_isAnimating) {
            for (var blob in _colorBlobs) {
              blob.update(_speed, _time, _circleRadius);
            }
          }
        });
      });

    // Initialize color blobs
    for (int i = 0; i < 4; i++) {
      _colorBlobs.add(ColorBlob(_circleRadius));
    }

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleAnimation() {
    setState(() {
      _isAnimating = !_isAnimating;
    });
  }

  void _changeSpeed() {
    setState(() {
      if (_speed == 1.0) {
        _speed = 2.5;
      } else if (_speed == 2.5) {
        _speed = 0.3;
      } else {
        _speed = 1.0;
      }
    });
  }

  void _changeBlur() {
    setState(() {
      if (_blurLevel == 8.0) {
        _blurLevel = 15.0;
      } else if (_blurLevel == 15.0) {
        _blurLevel = 3.0;
      } else {
        _blurLevel = 8.0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    return Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.0,
            colors: [Color(0xFF0a0a0a), Colors.black],
          ),
        ),
        child: Stack(
          children: [
            // Controls
            Positioned(
              top: 20,
              left: 20,
              child: Row(
                children: [
                  _buildControlButton('Toggle Animation', _toggleAnimation),
                  _buildControlButton('Change Speed', _changeSpeed),
                  _buildControlButton('Change Blur', _changeBlur),
                ],
              ),
            ),

            // Color Circle
            Center(
              child: ClipOval(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: _blurLevel,
                    sigmaY: _blurLevel,
                  ),
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.3),
                          blurRadius: 50,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: CustomPaint(
                      painter: ColorCirclePainter(
                        colorBlobs: _colorBlobs,
                        time: _time,
                        circleRadius: _circleRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
    );
  }

  Widget _buildControlButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class ColorCirclePainter extends CustomPainter {
  final List<ColorBlob> colorBlobs;
  final double time;
  final double circleRadius;

  ColorCirclePainter({
    required this.colorBlobs,
    required this.time,
    required this.circleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw background gradient
    final backgroundPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1.0,
        colors: [
          HSLColor.fromAHSL(1.0, time * 0.5 % 360, 0.8, 0.5).toColor(),
          HSLColor.fromAHSL(0.6, (time * 0.5 + 120) % 360, 0.7, 0.45).toColor(),
          HSLColor.fromAHSL(0.8, (time * 0.5 + 240) % 360, 0.75, 0.4).toColor(),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: circleRadius,
      ));

    // Draw circle background
    canvas.drawCircle(
      Offset(centerX, centerY),
      circleRadius,
      backgroundPaint,
    );

    // Draw all color blobs
    for (var blob in colorBlobs) {
      blob.draw(canvas, centerX, centerY);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ColorBlob {
  late double x, y;
  late double vx, vy;
  late double baseSize;
  late double hue;
  late double saturation;
  late double lightness;
  late double opacity;
  late double morphSpeed;
  late double colorSpeed;
  late List<BlobPoint> shapePoints;
  late List<BlobPoint> targetPoints;

  ColorBlob(double circleRadius) {
    reset(circleRadius);
  }

  void reset(double circleRadius) {
    final centerX = circleRadius;
    final centerY = circleRadius;
    x = centerX + (Random().nextDouble() - 0.5) * circleRadius;
    y = centerY + (Random().nextDouble() - 0.5) * circleRadius;
    vx = (Random().nextDouble() - 0.5) * 2;
    vy = (Random().nextDouble() - 0.5) * 2;
    baseSize = 60 + Random().nextDouble() * 100;
    hue = Random().nextDouble() * 360;
    saturation = 70 + Random().nextDouble() * 30;
    lightness = 45 + Random().nextDouble() * 35;
    opacity = 0.7 + Random().nextDouble() * 0.3;
    morphSpeed = 0.02 + Random().nextDouble() * 0.03;
    colorSpeed = 0.2 + Random().nextDouble() * 1.5;

    // Generate initial irregular shape points
    generateShape();
  }

  void generateShape() {
    final pointCount = 6 + Random().nextInt(6);
    shapePoints = [];
    targetPoints = [];

    for (int i = 0; i < pointCount; i++) {
      final angle = (i / pointCount) * pi * 2;
      final radius = 0.5 + Random().nextDouble() * 0.8;
      shapePoints.add(BlobPoint(angle: angle, radius: radius, targetRadius: radius));
      targetPoints.add(BlobPoint(angle: angle, radius: 0.3 + Random().nextDouble() * 1.2,targetRadius: 0.3 + Random().nextDouble() * 1.2));
    }
  }

  void update(double speed, double time, double circleRadius) {
    final centerX = circleRadius;
    final centerY = circleRadius;

    // Move freely in any direction
    x += vx * speed;
    y += vy * speed;

    // Bounce off circle boundaries
    final distFromCenter = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2));
    if (distFromCenter > circleRadius - 20) {
      final angle = atan2(y - centerY, x - centerX);
      vx = -cos(angle) * vx.abs();
      vy = -sin(angle) * vy.abs();
    }

    // Random direction changes
    if (Random().nextDouble() < 0.01) {
      vx += (Random().nextDouble() - 0.5) * 0.5;
      vy += (Random().nextDouble() - 0.5) * 0.5;

      // Limit velocity
      const maxVel = 3.0;
      if (vx.abs() > maxVel) vx = vx.sign * maxVel;
      if (vy.abs() > maxVel) vy = vy.sign * maxVel;
    }

    // Morph shape continuously
    for (int i = 0; i < shapePoints.length; i++) {
      if (Random().nextDouble() < 0.02) {
        targetPoints[i].radius = 0.3 + Random().nextDouble() * 1.2;
      }
      // Smoothly interpolate to target
      shapePoints[i].radius += (targetPoints[i].radius - shapePoints[i].radius) * 0.02;
    }

    // Change size over time
    baseSize += sin(time * morphSpeed) * 2;
    if (baseSize < 40) baseSize = 40;
    if (baseSize > 180) baseSize = 180;

    // Shift colors continuously
    hue += colorSpeed * speed;
    if (hue > 360) hue -= 360;
  }

  void draw(Canvas canvas, double centerX, double centerY) {
    final path = Path();
    bool firstPoint = true;

    for (var point in shapePoints) {
      final xPos = x + cos(point.angle) * point.radius * baseSize;
      final yPos = y + sin(point.angle) * point.radius * baseSize;

      if (firstPoint) {
        path.moveTo(xPos, yPos);
        firstPoint = false;
      } else {
        path.lineTo(xPos, yPos);
      }
    }
    path.close();

    // Create gradient for the blob
    final gradient = RadialGradient(
      center: Alignment.center,
      radius: 1.0,
      colors: [
        HSLColor.fromAHSL(opacity, hue, saturation / 100, lightness / 100).toColor(),
        HSLColor.fromAHSL(opacity * 0.7, hue + 30, saturation / 100, (lightness - 10) / 100)
            .toColor(),
        HSLColor.fromAHSL(0, hue + 60, saturation / 100, (lightness - 20) / 100).toColor(),
      ],
      stops: const [0.0, 0.7, 1.0],
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromCircle(
        center: Offset(x, y),
        radius: baseSize,
      ));

    canvas.drawPath(path, paint);
  }
}

class BlobPoint {
  double angle;
  double radius;
  double targetRadius;

  BlobPoint({
    required this.angle,
    required this.radius,
    required this.targetRadius,
  });
}
