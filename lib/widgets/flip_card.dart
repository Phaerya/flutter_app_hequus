import 'package:flutter/material.dart';
import 'dart:math';

class FlipCard extends StatefulWidget {
  final String frontImage;
  final String backImage;
  final bool isFlipped;

  const FlipCard({
    Key? key,
    required this.frontImage,
    required this.backImage,
    this.isFlipped = false,
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void didUpdateWidget(FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped && !oldWidget.isFlipped) {
      _controller.forward(); // Lancer l'animation
    } else if (!widget.isFlipped && oldWidget.isFlipped) {
      _controller.reverse(); // Revenir à l'animation inverse
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(value * pi), // Rotation de la carte
          child: value < 0.5
              ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xFF253031),
              image: DecorationImage(
                image: AssetImage(widget.backImage),
                fit: BoxFit.cover,
              ),
            ),
          )
              : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: const Color(0xFF253031),
              image: DecorationImage(
                image: AssetImage(widget.frontImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
