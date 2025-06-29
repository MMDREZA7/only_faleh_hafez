import 'dart:io';
import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/application/omen_list/omen_bloc.dart';
import 'package:faleh_hafez/application/omen_list/omens.dart';
import 'package:faleh_hafez/application/theme_changer/theme_changer_bloc.dart';
import 'package:faleh_hafez/presentation/about/about_us.dart';
import 'package:faleh_hafez/presentation/messenger/pages/login%20&%20register/login_page_chat.dart';
import 'package:faleh_hafez/presentation/themes/theme.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'button.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

submitSearchDialog(BuildContext context, String searchingText) async {
  if (searchingText == '786') {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => AuthenticationBloc(),
          child: BlocProvider(
            create: (context) =>
                ChatThemeChangerBloc()..add(FirstTimeOpenChat()),
            child: const LoginPageMessenger(),
          ),
        ),
      ),
    );
    return;
  }
  if (int.parse(searchingText) <= 0) {
    context.showErrorBar(
      content: const Text(
        'عدد غزل ها از عدد 1 شروع میشود',
      ),
    );
    return;
  }
  if (int.parse(searchingText) > omens.length - 1) {
    context.showErrorBar(
      content: Text(
        'تعداد غزل ها :${omens.length - 1} اما شما بیشتر ورودی شما بیشتر از تعداد غزل ها بود\n مجددا امتحان کنید',
      ),
    );
    return;
  } else {
    if (searchingText.isNotEmpty) {
      context.read<OmenBloc>().add(
            OmenSearchedEvent(
              searchIndex: searchingText,
            ),
          );

      Navigator.pop(context);
    } else {
      context.showErrorBar(
        content: const Text(
          'لطفا عددی وارد کنید یا دکمه انصراف را بزنید',
        ),
      );
    }
  }
}

exitApplication(BuildContext context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '❤ به امید دیدار',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );

  await Future.delayed(
    const Duration(seconds: 2),
  );

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => exit(0),
    ),
  );
}

class _MyDrawerState extends State<MyDrawer> {
  final TextEditingController _searchController = TextEditingController();

  FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white24,
      shadowColor: Colors.green,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // logo
            DrawerHeader(
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: Image.asset(
                    'assets/icon/Hafez_Omen-PNG.png',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),

            // name of app
            Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'فال حافظ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'iranNastaliq',
                      fontSize: 35,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 2,
              color: Theme.of(context).colorScheme.primary,
            ),

            // about us page
            MyButton(
              icon: Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutUsPage(),
                  ),
                );
              },
              text: 'درباره ما',
              height: 60,
              width: double.infinity,
            ),

            // change app theme
            MyButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onTap: () {
                context.read<ThemeChangerBloc>().add(ChangeThemeEvent());
              },
              text: 'عوض کردن تم',
              height: 60,
              width: double.infinity,
            ),

            // search in ghazals
            MyButton(
              onTap: () async {
                Navigator.pop(context);

                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    title: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Text(
                        'لطفا عدد غزل مورد نظرتان را وارد کنید.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    content: Container(
                      padding: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextFormField(
                          autofocus: true,
                          focusNode: _searchFocusNode,
                          controller: _searchController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          decoration: InputDecoration(
                            hintText: 'محل وارد کردن عدد',
                            hintStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            border: InputBorder.none,
                          ),
                          onEditingComplete: () => submitSearchDialog(
                              context, _searchController.text),
                        ),
                      ),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // cancel button
                          MaterialButton(
                            color: Theme.of(context).colorScheme.onPrimary,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'انصراف',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          // search button
                          MaterialButton(
                            color: Theme.of(context).colorScheme.onPrimary,
                            onPressed: () => submitSearchDialog(
                                context, _searchController.text),
                            child: Text(
                              'جست و جو',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
              text: 'جست و جوی غزل',
              height: 60,
              width: double.infinity,
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),

            // Exit button
            MyButton(
              onTap: () => exitApplication(context),
              color: Colors.red,
              textColor: Colors.white,
              text: "خروج",
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
