import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class UserLocationMarker extends StatefulWidget {
  final double heading;

  const UserLocationMarker({super.key, this.heading = 0});

  @override
  State<UserLocationMarker> createState() => _UserLocationMarkerState();
}

class _UserLocationMarkerState extends State<UserLocationMarker> 
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulse,
      builder: (_, child) {
        return Stack (
          alignment: Alignment.center,
          children: [
            Transform.scale(
              scale: 1 + _pulse.value * 0.8,
              child: Opacity(
                opacity: (1 - _pulse.value) * 0.4,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),

            Transform.rotate(angle: widget.heading * pi / 180, child: child!),
          ],
        );
      },
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withAlpha(100),

                blurRadius: 8,
                spreadRadius: 2,
              )
            ]
          ),
          child: const Icon(
            Icons.navigation_rounded,
            size: 10,
            color: Colors.white,
          ),
        ),
    );
  }
}

class DestinationMarker extends StatelessWidget {
  const DestinationMarker({super.key});

  @override
  Widget build(BuildContext context){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withAlpha(100),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.place_rounded, size: 18, color: Colors.white),
        ),
        CustomPaint(size: const Size(10, 8), painter: _PinTailPainter()),
      ],
    ).animate().scale(
      begin: const Offset(0.4, 0.4),
      duration: 300.ms,
      curve: Curves.elasticOut,
    );
  }
}

class _PinTailPainter extends CustomPainter {
  @override

  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = const Color(0xFFE53935)
    ..style = PaintingStyle.fill;
    final path = Path()
    ..moveTo(0, 0)
    ..lineTo(size.width, 0)
    ..lineTo(size.width / 2, size.height)
    ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class NavigationMarker extends StatelessWidget {
  final double bearing;

  const NavigationMarker({super.key, this.bearing = 0});
  
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: bearing * pi / 180,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF00BCD4),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlueAccent.withAlpha(125),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ]
        ),
        child: const Icon(
          Icons.navigation_rounded,
          size: 18,
          color: Colors.white,
        ),
      )
    );
  }
}