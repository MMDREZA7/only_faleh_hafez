import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class FailureView extends StatelessWidget {
  const FailureView({
    Key? key,
    required this.message,
    required this.onTapTryAgain,
    this.tryAgainText,
  }) : super(key: key);

  final String? message;
  final String? tryAgainText;
  final VoidCallback onTapTryAgain;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: message ?? 'Some Error Happened.',
                  style: TextStyle(
                    fontFamily: 'iranSans',
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                TextSpan(
                  text: tryAgainText ?? '   تلاش دوباره',
                  style: TextStyle(
                    fontFamily: 'iranSans',
                    color: Colors.black,
                    fontSize: 20,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = onTapTryAgain,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
