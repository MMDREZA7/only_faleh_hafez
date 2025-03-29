import 'package:faleh_hafez/application/authentiction/authentication_bloc.dart';
import 'package:faleh_hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:faleh_hafez/application/omen_list/omen_bloc.dart';
import 'package:faleh_hafez/application/theme_changer/theme_changer_bloc.dart';
import 'package:faleh_hafez/domain/models/group_chat_dto.dart';
import 'package:faleh_hafez/presentation/home/home_page.dart';
import 'package:faleh_hafez/presentation/home/components/splash_page.dart';
import 'package:faleh_hafez/presentation/home/search/search_page.dart';
import 'package:faleh_hafez/presentation/messenger/group_profile/group_profile_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/login%20&%20register/login_page_chat.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/router_navbar_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/home_chats_page.dart';
import 'package:faleh_hafez/presentation/messenger/pages/messenger_pages/public_chats_page.dart';
import 'package:faleh_hafez/presentation/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open box
  // ignore: unused_local_variable
  var box = await Hive.openBox('myBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      //

      //! load splash page

      future: Future.delayed(
        const Duration(seconds: 0),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: darkTheme,
            home: const SplashPage(),
          );
        } else {
          //

          //! load menu page

          return MultiBlocProvider(
            providers: [
              BlocProvider(
                  create: (context) =>
                      ChatThemeChangerBloc()..add(FirstTimeOpenChat())),
              BlocProvider(
                create: (context) =>
                    ThemeChangerBloc()..add(FirstTimeToOpenApp()),
              ),
              BlocProvider(
                create: (context) => OmenBloc(),
              ),
              BlocProvider(
                create: (context) => AuthenticationBloc(),
              ),
            ],
            child: BlocBuilder<ChatThemeChangerBloc, ChatThemeChangerState>(
              builder: (context, state) {
                if (state is ChatThemeChangerLoaded) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: state.theme,
                    // home: const PublicChatsPage(),
                    // home: const HomeChatsPage(),
                    // home: const ProfilePage(),
                    home: const RouterNavbarPage(),
                  );
                }
                // child: BlocBuilder<ThemeChangerBloc, ThemeChangerState>(
                //   builder: (context, state) {
                //     if (state is ThemeChangerLoading) {
                //       return const MaterialApp(
                //         debugShowCheckedModeBanner: false,
                //         home: SplashPage(),
                //       );
                //     }
                //     if (state is ThemeChangerLoaded) {
                //       return MaterialApp(
                //         debugShowCheckedModeBanner: false,
                //         theme: state.theme,
                //         // home: const HomeChatsPage(),
                //         // home: const LoginPageMessenger(),
                //         // home: const ProfilePage(),
                //         // home: const GroupProfilePage(),
                //         // home: const SearchPage(),
                //         // home: const SplashPage(),
                //         // home: const HomePage(),
                //         home: const RouterNavbarPage(),
                //       );
                //     }
                else {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: darkTheme,
                    home: const SplashPage(),
                  );
                }
              },
            ),
          );
        }
      },
    );
  }
}
