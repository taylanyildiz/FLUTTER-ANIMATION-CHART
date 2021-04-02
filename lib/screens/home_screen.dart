import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  AnimationController controller, controller2;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    controller2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = Tween<double>(begin: 0.0, end: 1.0).animate(controller);
    animation.addListener(() {
      setState(() {});
    });
    Future.delayed(Duration(milliseconds: 100),
        () => controller.forward().whenComplete(() => controller2.forward()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          color: Colors.red,
          child: CustomPaint(
            painter: CustomChart(
              animation: controller2.view,
              offset: animation.value,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomChart extends CustomPainter {
  CustomChart({
    Animation<double> animation,
    this.offset,
  })  : paintVertical = Paint()
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke,
        paintGraph = Paint()
          ..color = Colors.blue
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke,
        finishCircle = Paint()
          ..color = Colors.blue
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke,
        startCircle = Paint()
          ..color = Colors.blue
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke,
        strokeCircleBlue = Paint()
          ..color = Colors.blue
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke,
        fillCircleWhite = Paint()
          ..color = Colors.white
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.fill,
        animationCircle = Tween<double>(begin: 0.0, end: pi / 2).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.elasticOut,
          ),
        ),
        super(repaint: animation);
  final Paint paintVertical;
  final Paint paintGraph;
  final Paint startCircle;
  final Paint finishCircle;
  final Paint strokeCircleBlue, fillCircleWhite;
  final double offset;
  final Animation<double> animationCircle;
  @override
  void paint(Canvas canvas, Size size) {
    drawBackgroundVertical(canvas, size);
    drawGraph(canvas, size);
  }

  void drawGraph(Canvas canvas, Size size) {
    Path path = createPath(size);
    try {
      PathMetric pathMetric = path.computeMetrics().first;
      Path extractPath =
          pathMetric.extractPath(0.0, pathMetric.length * offset);
      canvas.drawPath(extractPath, paintGraph);
      var metric = extractPath.computeMetrics().first;
      final circleOffsetStart = metric.getTangentForOffset(0).position;
      final circleOffsetFinish =
          metric.getTangentForOffset(metric.length).position;
      canvas.drawCircle(circleOffsetStart, 5.0, fillCircleWhite);
      canvas.drawCircle(circleOffsetStart, 5.0, strokeCircleBlue);
      canvas.drawCircle(circleOffsetFinish, 5.0 * sin(animationCircle.value),
          fillCircleWhite);
      canvas.drawCircle(circleOffsetFinish, 5.0 * sin(animationCircle.value),
          strokeCircleBlue);
    } catch (e) {}
  }

  Path createPath(Size size) {
    Path path = Path();

    path.moveTo(size.width / 20, size.height / 5.5);
    path.quadraticBezierTo(
      size.width / 6,
      size.height / 6.5,
      size.width / 6,
      size.height / 3.5,
    );
    path.quadraticBezierTo(
      size.width / 6,
      size.height / 1.8,
      size.width / 3,
      size.height / 2.0,
    );
    path.quadraticBezierTo(
      size.width / 1.6,
      size.height / 2.4,
      size.width / 1.6,
      size.height / 1.6,
    );
    path.quadraticBezierTo(
      size.width / 1.6,
      size.height,
      size.width * .9,
      size.height * .9,
    );
    return path;
  }

  void drawBackgroundVertical(Canvas canvas, Size size) {
    for (var i = 0; i < 5; i++) {
      Offset c = Offset(0, size.height * i / 4);
      Offset c1 = Offset(size.width, size.height * i / 4);
      canvas.drawLine(c, c1, paintVertical);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
