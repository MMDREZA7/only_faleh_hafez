import 'package:faleh_hafez/application/omen_list/omen_bloc.dart';
import 'package:faleh_hafez/presentation/home/components/button.dart';
import 'package:faleh_hafez/presentation/home/home_page.dart';
import 'package:faleh_hafez/presentation/home/search/components/poem_search_container.dart';
import 'package:faleh_hafez/presentation/home/search/poem_searched_page.dart';
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
            ),
            BlocBuilder<OmenBloc, OmenState>(
              builder: (context, state) {
                if (state is OmenLoading) {
                  return MyButton(
                    onTap: () {},
                    color: Theme.of(context).colorScheme.primary,
                    horizontalMargin: 10,
                    verticalMargin: 5,
                    child: const CircularProgressIndicator(),
                  );
                }

                return MyButton(
                  onTap: () {
                    if (_searchController.text.isEmpty) {
                      showSnackBar(
                        "لطفا فیلد جست و جو را کامل کنید",
                        Colors.red,
                      );
                      return;
                    }
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
                return Center(
                  child: Column(
                    children: [
                      const Text("مشکلی پیش آمده است لطفا مجددا تلاش کنید"),
                      MyButton(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                );
              }

              return const Center(
                child: Text("Hello Somthing went wrong"),
              );
            }),
          ],
        ),
      ),
    );
  }
}
