// import 'dart:math';

// import 'package:flutter/material.dart';

// class ArcGraph extends StatefulWidget {
//   final double percentage;
//   final double size;
//   final Color color;

//   const ArcGraph({
//     super.key,
//     required this.percentage,
//     required this.size,
//     required this.color,
//   });

//   @override
//   State<ArcGraph> createState() => _ArcGraphState();
// }

// class _ArcGraphState extends State<ArcGraph>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: Duration(milliseconds: 1000),
//     );

//     _animation = Tween<double>(
//       begin: 0,
//       end: widget.percentage,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));

//     _controller.forward();
//   }

//   @override
//   void didUpdateWidget(ArcGraph oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.percentage != widget.percentage) {
//       _animation = Tween<double>(
//         begin: oldWidget.percentage,
//         end: widget.percentage,
//       ).animate(CurvedAnimation(
//         parent: _controller,
//         curve: Curves.easeInOut,
//       ));
//       _controller.forward(from: 0);
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, child) {
//         return CustomPaint(
//           size: Size(widget.size, widget.size / 2),
//           painter: ArcGraphPainter(
//               percentage: _animation.value, color: widget.color),
//         );
//       },
//     );
//   }
// }

// class ArcGraphPainter extends CustomPainter {
//   final double percentage;
//   final Color color;

//   ArcGraphPainter({required this.percentage, required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint basePaint = Paint()
//       ..color = Colors.grey.shade300
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5.0
//       ..strokeCap = StrokeCap.round;

//     final Paint progressPaint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 5.0
//       ..strokeCap = StrokeCap.round;

//     final double startAngle = (5 * pi) / 6;
//     final double sweepAngle = (4 * pi) / 3;
//     final double progressSweep = sweepAngle * (percentage / 100);

//     final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

//     canvas.drawArc(rect, startAngle, sweepAngle, false, basePaint);
//     canvas.drawArc(rect, startAngle, progressSweep, false, progressPaint);
//   }

//   @override
//   bool shouldRepaint(covariant ArcGraphPainter oldDelegate) {
//     return oldDelegate.percentage != percentage;
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';

class ArcGraph extends StatefulWidget {
  final double percentage;
  final double size;
  final Color color;

  const ArcGraph({
    super.key,
    required this.percentage,
    required this.size,
    required this.color,
  });

  @override
  State<ArcGraph> createState() => _ArcGraphState();
}

class _ArcGraphState extends State<ArcGraph>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _animation = Tween<double>(
      begin: 0,
      end: widget.percentage,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(ArcGraph oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _animation = Tween<double>(
        begin: oldWidget.percentage,
        end: widget.percentage,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size(widget.size, widget.size / 2),
              painter: ArcGraphPainter(
                  percentage: _animation.value, color: widget.color),
            ),
          ],
        );
      },
    );
  }
}

class ArcGraphPainter extends CustomPainter {
  final double percentage;
  final Color color;

  ArcGraphPainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint basePaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    final double startAngle = (5 * pi) / 6;
    final double sweepAngle = (4 * pi) / 3;
    final double progressSweep = sweepAngle * (percentage / 100);

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);

    canvas.drawArc(rect, startAngle, sweepAngle, false, basePaint);
    canvas.drawArc(rect, startAngle, progressSweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant ArcGraphPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.color != color;
  }
}
