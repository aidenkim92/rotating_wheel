import 'package:flutter/material.dart';
import 'dart:math';

// TODO: Divide these into Microservices Structure
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
            child: RotatingWheel(
              size: 400,
            ),
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
    required this.size,
  });

  /// The height and width of the square space allocated to this
  /// [RotatingWheel]
  final double size;

  /// The color to show in the middle of the donut / wheel
  final Color foregroundColor;

  /// The color to show in the middle of the donut / wheel
  final Color backgroundColor;
  @override
  State<RotatingWheel> createState() => _RotatingWheelState();
}

class _RotatingWheelState extends State<RotatingWheel>
    with SingleTickerProviderStateMixin {
  Offset? panStart;
  double?
  panStartRadians; // Calculation between the start point and the centre point
  double? deltaRadians;
  double? reverseDeltaRadians;

  Offset get centre => Offset(widget.size / 2, widget.size / 2);

  late final AnimationController _reverseRotationController;

  @override
  void initState() {
    _reverseRotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    super.initState();
  }

  void _onPanStart(DragStartDetails details) {
    panStart = details.localPosition;
    panStartRadians = atan2(panStart!.dy - centre.dy, panStart!.dx - centre.dx);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final dragRadians = atan2(
      details.localPosition.dy - centre.dy,
      details.localPosition.dx - centre.dx,
    );

    setState(() {
      deltaRadians = dragRadians - panStartRadians!;
      print(deltaRadians);
    });
  }

  void _onPanEnd(DragEndDetails details) {
    print('RELEASED');
    _reverseRotationController.addListener(() {
      setState(() {
        reverseDeltaRadians =
            deltaRadians! * (1 - _reverseRotationController.value);
      });
    });
    _reverseRotationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          deltaRadians = null;
          reverseDeltaRadians = null;
        });
      }
    });
    _reverseRotationController.reset();
    _reverseRotationController.animateTo(
      1,
      duration: Duration(milliseconds: 2000),
      curve: Curves.bounceOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        const double wheelThickness = 50;

        double radiansToUse = reverseDeltaRadians ?? deltaRadians ?? 0;
        print('radiansToUse: $radiansToUse');

        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.rotate(
            angle: radiansToUse,
            child: Stack(
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
                  child: Transform.rotate(
                    angle: -radiansToUse,
                    child: Icon(
                      Icons.flutter_dash_outlined,
                      color: widget.backgroundColor,
                      size: wheelThickness,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _reverseRotationController.dispose();
    super.dispose();
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
