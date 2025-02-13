import 'package:faleh_hafez/application/omen_list/omen_bloc.dart';
import 'package:faleh_hafez/application/theme_changer/theme_changer_bloc.dart';
import 'package:faleh_hafez/presentation/home/components/Quick_guide_dialog.dart';
import 'package:faleh_hafez/presentation/home/components/button.dart';
import 'package:faleh_hafez/presentation/home/components/drawer_main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ThemeChangerBloc>().add(FirstTimeToOpenApp());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: AppBar(
        actions: [
          // IconButton(
          //   onPressed: () => Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => ExamplePage(),
          //     ),
          //   ),
          //   icon: const Icon(
          //     Icons.group,
          //     color: Colors.black,
          //   ),
          // ),
          IconButton(
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (context) => const QuickGuideDialog(
                  text:
                      'برای استفاده از برنامه، شما باید دکمه ی پایین صفحه را فشار دهید و سپس منتظر بمانید تا فال شما نمایان شود',
                ),
              );

              // ignore: use_build_context_synchronously
              await showDialog(
                context: context,
                builder: (context) => const QuickGuideDialog(
                  text:
                      "همچنین شما میتوانید در منوی سمت چپ صفحه درباره اپلیکشین (فال حافظ) بیشتر بدانید",
                ),
              );

              // ignore: use_build_context_synchronously
              await showDialog(
                context: context,
                builder: (context) => const QuickGuideDialog(
                  text:
                      'برای عوض کردن تِم برنامه ، میتوانید به منوی سمت چپ صفحه مراجعه کنید و سپس دکمه "عوض کردن تِم"را کلیک کنید',
                ),
              );
            },
            icon: Icon(
              Icons.help,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          )
        ],
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'فال حافظ',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Tomb_of_hafez.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: BlocBuilder<OmenBloc, OmenState>(
              builder: (context, state) {
                if (state is OmenLoading) {
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                    strokeWidth: 6,
                  );
                }
                if (state is OmenLoaded) {
                  return Column(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          padding: const EdgeInsets.all(10),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(15),
                          ),

                          //* user's omen
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: ListView(
                                children: [
                                  // poem text
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      state.omen.poemText,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'vazir',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  // divider
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 10),
                                    child: Divider(
                                      thickness: 2,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary,
                                    ),
                                  ),

                                  // tafsir text
                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      'تفسیر :',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'vazir',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),

                                  Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Text(
                                      state.omen.omenText,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: 'vazir',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // give user's omen button for second time
                      MyButton(
                        onTap: () {
                          context.read<OmenBloc>().add(OmenGetRandomEvent());
                        },
                        text: 'ابتدا نیت کنید و سپس کلیک کنید',
                        height: 80,
                        width: double.infinity,
                        icon: Icon(
                          Icons.get_app,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  );
                }
                if (state is OmenError) {
                  return Center(
                    child: Text(
                      state.errorMessage,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  );
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // give user's omen button for first time

                    MyButton(
                      onTap: () {
                        context.read<OmenBloc>().add(
                              OmenGetRandomEvent(),
                            );
                      },
                      text: 'ابتدا نیت کنید و سپس کلیک کنید',
                      height: 80,
                      width: double.infinity,
                      icon: Icon(
                        Icons.get_app,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
