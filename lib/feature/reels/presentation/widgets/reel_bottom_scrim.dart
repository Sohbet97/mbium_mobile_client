import 'package:flutter/material.dart';

/// Solid black strip below the reel video — a real layout sibling (not a
/// [Positioned] overlay drawn on top of the video), so the video and this
/// bar are two separate widgets stacked vertically via [Column].
class ReelBottomScrim extends StatelessWidget {
  const ReelBottomScrim({super.key, this.height = 54});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: const ColoredBox(color: Colors.black),
    );
  }
}
