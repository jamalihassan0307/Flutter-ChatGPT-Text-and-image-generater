import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;

  const LoadingWidget({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
} 