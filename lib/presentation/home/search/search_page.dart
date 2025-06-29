import 'package:faleh_hafez/application/omen_list/omen_bloc.dart';
import 'package:faleh_hafez/presentation/home/components/button.dart';
import 'package:faleh_hafez/presentation/home/home_page.dart';
import 'package:faleh_hafez/presentation/home/search/components/poem_search_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  showSnackBar(String text, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Directionality(
          textDirection: TextDirection.rtl,
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OmenBloc()..add(OmenSearchedGetPoemsEvent()),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              CupertinoIcons.left_chevron,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "جست و جو در اشعار",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 3,
                  color: Colors.white,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          label: Text(
                            "جست و جو",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          _searchController.clear();
                        },
                        icon: const Icon(
                          Icons.close,
                          weight: 50,
                          size: 25,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            BlocBuilder<OmenBloc, OmenState>(
              builder: (context, state) {
                if (state is OmenLoading) {
                  return MyButton(
                    onTap: () {},
                    color: Theme.of(context).colorScheme.primary,
                    horizontalMargin: 10,
                    verticalMargin: 10,
                    child: const Center(
                      child: Text("اندکی صبر کنید ..."),
                    ),
                  );
                }

                return MyButton(
                  onTap: () {
                    // if (_searchController.text.isEmpty) {
                    //   showSnackBar(
                    //     "لطفا فیلد جست و جو را کامل کنید",
                    //     Colors.red,
                    //   );
                    //   return;
                    // }
                    context.read<OmenBloc>().add(
                          OmenSearchedPoemEvent(
                            searchString: _searchController.text,
                          ),
                        );
                  },
                  text: "جست و جو کردن",
                  color: Theme.of(context).colorScheme.primary,
                  horizontalMargin: 10,
                  verticalMargin: 5,
                );
              },
            ),
            BlocBuilder<OmenBloc, OmenState>(builder: (context, state) {
              if (state is OmenLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                );
              }

              //? First Time Loaded SearchPage
              if (state is OmenSearchingLoaded) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.omens.length,
                    itemBuilder: (context, index) => PoemSerachContainer(
                      indexLeading: index,
                      title: state.omens[index].title,
                      navigateTO: state.omens[index],
                    ),
                  ),
                );
              }

              //? SearchPage When Shearch something
              if (state is OmenLoaded) {
                return ListView.builder(
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Text(
                        state.omen.poemText!,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (state is OmenError) {
                // showSnackBar(state.errorMessage, Colors.red);
                return Center(
                  child: Column(
                    children: [
                      Text(
                        state.errorMessage,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      MyButton(
                        horizontalMargin: 25,
                        text: 'بازگشت به صفحه اصلی',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (context) => OmenBloc(),
                                child: const HomePage(),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              }

              return const Center(
                child: Text("چیزی پیدا نشد متاسفانه"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
