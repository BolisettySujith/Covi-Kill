import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class Bubbles extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BubblesState();
  }
}

class _BubblesState extends State<Bubbles> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> bubbles;
  final int numberOfBubbles = 500;
  final Color color = Colors.amber;
  final double maxBubbleSize = 20.0;

  @override
  void initState() {
    super.initState();
    var physicalScreenSize = window.physicalSize;
    var physicalWidth = physicalScreenSize.width;
    var physicalHeight = physicalScreenSize.height;

    // Initialize bubbles
    bubbles = [];
    int i = numberOfBubbles;
    while (i > 0) {
      bubbles.add(Bubble(color, maxBubbleSize, physicalWidth, physicalHeight));
      i--;
    }

    // Init animation controller
    _controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    _controller.addListener(() {
      updateBubblePosition();
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.6),
        body: Center(
          child: Center(
            child: CustomPaint(
              foregroundPainter: BubblePainter(bubbles: bubbles),
              size: Size(MediaQuery.of(context).size.width,
                  MediaQuery.of(context).size.height),
            ),
          ),
        ),
      ),
    );
  }

  void updateBubblePosition() {
    bubbles.forEach((it) => it.updatePosition());
    setState(() {});
  }
}

class BubblePainter extends CustomPainter {
  List<Bubble> bubbles;

  BubblePainter({required this.bubbles});

  @override
  void paint(Canvas canvas, Size canvasSize) {
    bubbles.forEach((it) => it.draw(canvas, canvasSize));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Bubble {
  late Color colour;
  late double direction;
  late double speed;
  late double radius;
  late double x;
  late double y;

  Bubble(Color colour, double maxBubbleSize, double x, double y) {
    this.colour = colour.withOpacity(Random().nextDouble());
    direction = Random().nextDouble() * 360;
    speed = 4;
    radius = Random().nextDouble() * maxBubbleSize;
    this.x = x / 6;
    this.y = y / 6;
  }

  draw(Canvas canvas, Size canvasSize) {
    Paint paint = new Paint()
      ..color = colour
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    assignRandomPositionIfUninitialized(canvasSize);

    randomlyChangeDirectionIfEdgeReached(canvasSize);

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void assignRandomPositionIfUninitialized(Size canvasSize) {
    if (x == null) {
      this.x = Random().nextDouble() * canvasSize.width;
    }

    if (y == null) {
      this.y = Random().nextDouble() * canvasSize.height;
    }
  }

  updatePosition() {
    var a = 180 - (direction + 90);
    direction > 0 && direction < 180
        ? x += speed * sin(direction) / sin(speed)
        : x -= speed * sin(direction) / sin(speed);
    direction > 90 && direction < 270
        ? y += speed * sin(a) / sin(speed)
        : y -= speed * sin(a) / sin(speed);
  }

  randomlyChangeDirectionIfEdgeReached(Size canvasSize) {
    if (x > canvasSize.width || x < 0 || y > canvasSize.height || y < 0) {
      direction = Random().nextDouble() * 360;
    }
  }
}
