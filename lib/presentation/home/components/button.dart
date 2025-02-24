import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String? text;
  final double? width;
  final double? height;
  final void Function()? onTap;
  final Icon? icon;
  final color;
  final double? horizontalMargin;
  final double? verticalMargin;
  final Widget? child;

  const MyButton({
    super.key,
    required this.onTap,
    this.text,
    this.height,
    this.width,
    this.icon,
    this.color,
    this.horizontalMargin,
    this.verticalMargin,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin ?? 0,
          vertical: verticalMargin ?? 5,
        ),
        decoration: BoxDecoration(
          color: color ?? Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        width: width,
        height: height,
        child: Center(
          child: ListTile(
            titleAlignment: ListTileTitleAlignment.center,
            trailing: icon,
            iconColor: Colors.white,
            title: Directionality(
              textDirection: TextDirection.rtl,
              child: child ??
                  Text(
                    text ?? "",
                    style: TextStyle(
                      fontFamily: 'vazir',
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
