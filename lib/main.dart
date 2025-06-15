import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox.square(
            dimension: 400,
            child: RotatingWheel(),
          ),
        ),
      ),
    );
  }
}

class RotatingWheel extends StatefulWidget {
  const RotatingWheel({
    super.key,
    this.foregroundColor = Colors.red,
    this.backgroundColor = Colors.white,
  });

  /// The color to show in the middle of the donut / wheel
  final Color foregroundColor;

  /// The color to show in the middle of the donut / wheel
  final Color backgroundColor;
  @override
  State<RotatingWheel> createState() => _RotatingWheelState();
}

class _RotatingWheelState extends State<RotatingWheel> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        const double wheelThickness = 50;

        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: WheelPainter(
                  rotation: 0,
                  thickness: wheelThickness,
                  foregroundColor: widget.foregroundColor,
                  backgroundColor: widget.backgroundColor,
                ),
              ),
            ),
            Positioned(
              left: (constrains.maxWidth / 2) - (wheelThickness / 2),
              child: Icon(
                Icons.flutter_dash_outlined,
                color: widget.backgroundColor,
                size: wheelThickness,
              ),
            ),
          ],
        );
      },
    );
  }
}

class WheelPainter extends CustomPainter {
  const WheelPainter({
    required this.rotation,
    required this.thickness,
    required this.foregroundColor,
    required this.backgroundColor,
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
      Paint()..color = foregroundColor,
    );

    // Inner circle
    canvas.drawCircle(
      center,
      (size.height / 2) - thickness,
      Paint()..color = backgroundColor,
    );
  }

  @override
  bool shouldRepaint(WheelPainter oldDelegate) =>
      rotation != oldDelegate.rotation;
}
