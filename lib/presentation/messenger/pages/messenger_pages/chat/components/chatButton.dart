import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';

class ChatButton extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final double? width;
  final double? height;
  final void Function()? onTap;
  final Icon? icon;
  final Color? color;
  final double? horizontalMargin;
  final double? verticalMargin;
  final Widget? child;

  const ChatButton({
    super.key,
    required this.onTap,
    this.text,
    this.textColor,
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
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: horizontalMargin ?? 0,
                vertical: verticalMargin ?? 5,
              ),
              decoration: BoxDecoration(
                color: color ?? themeState.theme.colorScheme.primary,
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
                    child: Center(
                      child: child ??
                          Text(
                            text ?? "",
                            style: TextStyle(
                              fontFamily: 'iranSans',
                              color: textColor ??
                                  themeState.theme.colorScheme.onPrimary,
                              fontSize: 18,
                            ),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return const Center();
      },
    );
  }
}
