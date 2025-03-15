// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileItemsContainer extends StatefulWidget {
  dynamic leading;
  dynamic title;
  IconData? trailingIcon;
  void Function()? onClickTrailingButton;
  double? marginTop;
  double? marginButtom;
  double? marginRight;
  double? marginLeft;
  Color? boxColor;
  Color? leadingColor;

  ProfileItemsContainer({
    super.key,
    this.leading,
    this.title,
    this.trailingIcon,
    this.onClickTrailingButton,
    this.marginTop,
    this.marginButtom,
    this.marginRight,
    this.marginLeft,
    this.boxColor,
    this.leadingColor,
  });

  @override
  State<ProfileItemsContainer> createState() => _ProfileItemsContainerState();
}

class _ProfileItemsContainerState extends State<ProfileItemsContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        widget.marginLeft ?? 0,
        widget.marginTop ?? 0,
        widget.marginRight ?? 0,
        widget.marginButtom ?? 0,
      ),
      decoration: BoxDecoration(
        color: widget.boxColor ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(15),
        //   border: Border.symmetric(
        //   //   horizontal: BorderSide(
        //   //     width: 5,
        //   //     color: Theme.of(context).colorScheme.onPrimary,
        //   //   ),
        //   // ),
      ),
      child: ListTile(
        leading: widget.leading.runtimeType != String
            ? Icon(
                widget.leading,
                color: widget.leadingColor ??
                    Theme.of(context).colorScheme.onPrimary,
              )
            : Text(
                widget.leading,
                style: TextStyle(
                  fontSize: 15,
                  color: widget.leadingColor ??
                      Theme.of(context).colorScheme.onPrimary,
                ),
              ),
        title: widget.title.runtimeType == String
            ? Text(
                widget.title ?? '',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              )
            : widget.title,
        trailing: IconButton(
          onPressed: widget.onClickTrailingButton,
          icon: Icon(
            widget.trailingIcon,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
