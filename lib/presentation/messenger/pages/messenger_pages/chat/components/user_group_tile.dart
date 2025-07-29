import 'dart:math';
import 'dart:typed_data';

import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/message_dto.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersGroupsTile extends StatefulWidget {
  String title;
  String subTitle;
  void Function() onTap;
  Widget trailing;
  Widget leading;
  ThemeData themeState;

  UsersGroupsTile({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onTap,
    required this.trailing,
    required this.leading,
    required this.themeState,
  });

  @override
  State<UsersGroupsTile> createState() => _UsersGroupsTileState();
}

class _UsersGroupsTileState extends State<UsersGroupsTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: widget.onTap,
          child: Container(
            padding: const EdgeInsets.all(5),
            // decoration: BoxDecoration(
            //   border: BorderDirectional(
            //     bottom: BorderSide(
            //       width: 2,
            //       color: widget.themeState.colorScheme.secondary,
            //     ),
            //   ),
            //   //   borderRadius: const BorderRadius.only(
            //   //     bottomLeft: Radius.circular(12),
            //   //     bottomRight: Radius.circular(12),
            //   //     topRight: Radius.circular(12),
            // ),
            // color: widget.themeState.primaryColor,
            // ),
            margin: const EdgeInsets.only(
              // left: 15,
              // right: 15,
              top: 5,
            ),
            child: ListTile(
              title: Text(
                widget.title,
                style: TextStyle(
                  fontFamily: 'iranSans',
                  color: widget.themeState.colorScheme.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              leading: widget.leading,
              trailing: widget.trailing,
            ),
          ),
        ),
        const Divider(
          height: 1,
          indent: 70,
          color: Colors.white24,
        ),
      ],
    );
  }
}
