import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/chat_theme_changer/chat_theme_changer_bloc.dart';

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
    return BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
      builder: (context, themeState) {
        if (themeState is ChatThemeChangerLoaded) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: boxColor ?? themeState.theme.colorScheme.background,
              ),
              child: ListTile(
                leading: Icon(
                  leadingIcon,
                  color: themeState.theme.colorScheme.onBackground,
                ),
                title: Text(
                  text ?? "Default Title",
                  style: TextStyle(
                    color:
                        textColor ?? themeState.theme.colorScheme.onBackground,
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

        return const Center();
      },
    );
  }
}
