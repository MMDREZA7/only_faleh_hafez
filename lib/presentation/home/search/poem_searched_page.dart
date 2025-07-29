// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:Faleh_Hafez/domain/models/omen/omen_dto.dart';

// ignore: must_be_immutable
class PoemSearchedPage extends StatefulWidget {
  OmenDTO omen;

  PoemSearchedPage({
    super.key,
    required this.omen,
  });

  @override
  State<PoemSearchedPage> createState() => _PoemSearchedPageState();
}

class _PoemSearchedPageState extends State<PoemSearchedPage> {
  final _titlesTextStyles = const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w300,
  );
  final _subTitlesTextStyles = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.omen.title,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: ListView(
                  children: [
                    // Ghazal Section
                    Text(
                      "غزل",
                      style: _titlesTextStyles,
                    ),
                    Text(
                      widget.omen.ghazal,
                      style: _subTitlesTextStyles,
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    Text(
                      "تفسیر غزل",
                      style: _titlesTextStyles,
                    ),
                    // Tafsir Section
                    Text(
                      widget.omen.tabirContent,
                      style: _subTitlesTextStyles,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
