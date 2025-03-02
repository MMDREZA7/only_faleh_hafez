import 'package:flutter/material.dart';

class DrawerItemChat extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final void Function()? onTap;
  final void Function()? onTapTrailing;
  final Color? boxColor;

  const DrawerItemChat({
    super.key,
    this.text,
    this.textColor,
    this.leadingIcon,
    this.trailingIcon,
    this.onTap,
    this.onTapTrailing,
    this.boxColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: boxColor ?? Theme.of(context).colorScheme.background,
        ),
        child: ListTile(
          leading: Icon(
            leadingIcon,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          title: Text(
            text ?? "Default Title",
            style: TextStyle(
              color: textColor ?? Theme.of(context).colorScheme.onBackground,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: IconButton(
            onPressed: onTapTrailing,
            icon: Icon(
              trailingIcon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
