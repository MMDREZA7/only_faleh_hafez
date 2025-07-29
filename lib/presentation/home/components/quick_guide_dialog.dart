import 'package:flutter/material.dart';

class QuickGuideDialog extends StatelessWidget {
  final String text;

  const QuickGuideDialog({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      actions: [
        TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Theme.of(context).colorScheme.onBackground,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            'Next',
            style: TextStyle(
              fontFamily: 'iranSans',
              fontSize: 20,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'iranSans',
                  fontWeight: FontWeight.w300,
                  fontSize: 22,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
