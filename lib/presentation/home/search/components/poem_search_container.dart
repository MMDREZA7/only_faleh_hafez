// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:faleh_hafez/domain/models/omen/omen_dto.dart';
import 'package:faleh_hafez/presentation/home/search/poem_searched_page.dart';
import 'package:flutter/material.dart';

class PoemSerachContainer extends StatefulWidget {
  final int? indexLeading;
  final String? title;
  final String? subTitle;
  final OmenDTO navigateTO;

  const PoemSerachContainer({
    super.key,
    this.indexLeading,
    this.title,
    this.subTitle,
    required this.navigateTO,
  });

  @override
  State<PoemSerachContainer> createState() => _PoemSerachContainerState();
}

class _PoemSerachContainerState extends State<PoemSerachContainer> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoemSearchedPage(
                omen: widget.navigateTO,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 3,
              color: Colors.white,
            ),
          ),
          child: ListTile(
            leading: Text(
              (widget.indexLeading! + 1).toString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            title: Text(
              widget.title ?? "Default Title",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
