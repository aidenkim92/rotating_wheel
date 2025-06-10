import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: RotatingWheel())),
    );
  }
}

class RotatingWheel extends StatefulWidget {
  const RotatingWheel({super.key});

  @override
  State<RotatingWheel> createState() => _RotatingWheelState();
}

class _RotatingWheelState extends State<RotatingWheel> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        width: 400,
        child: CustomPaint(
          painter: WheelPainter(
            rotation: 0,
            thickness: 30,
          ),
        ),
      ),
    );
  }
}

class WheelPainter extends CustomPainter {
  const WheelPainter({
    required this.rotation,
    required this.thickness,
    this.foregroundColor = Colors.red,
    this.backgroundColor = Colors.white,
  });

  /// In radians.
  final double rotation;

  /// Distance between outer and inner rings of the wheel
  final double thickness;

  /// The color to show in the middle of the donut / wheel
  final Color foregroundColor;

  /// The color to show in the middle of the donut / wheel
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate of the centre of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Outer circle
    canvas.drawCircle(
      center,
      size.height / 2,
      Paint()
        ..color = foregroundColor
    );

    // Inner circle
    canvas.drawCircle(
      center,
      (size.height / 2) - thickness,
      Paint()
        ..color = backgroundColor
    );
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) => rotation != oldDelegate.rotation;
}