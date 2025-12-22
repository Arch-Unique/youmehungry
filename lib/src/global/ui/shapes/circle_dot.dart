import 'package:flutter/material.dart';
import '/src/app/app_barrel.dart';

class CircleDot extends StatelessWidget {
  final Color color;
  final double size;

  const CircleDot({
    super.key,
    this.color = AppColors.primaryColor,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: AppColors.circleBorderColor,
      radius: size - 1,
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: color,
      ),
    );
  }
}
