import 'package:camera/utils/constants.dart';
import 'package:flutter/material.dart';

class BoxContainer extends StatelessWidget {
  final Widget child;
  const BoxContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          child,
        ],
      ),
    );
  }
}
