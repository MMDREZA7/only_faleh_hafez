import 'package:Faleh_Hafez/application/group_profile/group_profile_bloc.dart';
import 'package:Faleh_Hafez/application/theme_changer/theme_changer_bloc.dart';
import 'package:Faleh_Hafez/presentation/about/about_us.dart';
import 'package:Faleh_Hafez/presentation/home/components/splash_page.dart';
import 'package:Faleh_Hafez/presentation/home/home_page.dart';
import 'package:Faleh_Hafez/presentation/themes/theme.dart';
import 'package:Faleh_Hafez/Service/get_it/service_locator.dart';
import 'package:Faleh_Hafez/Service/signal_r/SignalR_Service.dart';
import 'package:Faleh_Hafez/application/authentiction/authentication_bloc.dart';
import 'package:Faleh_Hafez/application/chat_items/chat_items_bloc.dart';
import 'package:Faleh_Hafez/application/chat_theme_changer/chat_theme_changer_bloc.dart';
import 'package:Faleh_Hafez/application/messaging/bloc/messaging_bloc.dart';
import 'package:Faleh_Hafez/application/omen_list/omen_bloc.dart';
import 'package:Faleh_Hafez/application/theme_changer/theme_changer_bloc.dart';
import 'package:Faleh_Hafez/domain/models/group_chat_dto.dart';
import 'package:Faleh_Hafez/domain/models/user.dart';
import 'package:Faleh_Hafez/presentation/home/home_page.dart';
import 'package:Faleh_Hafez/presentation/home/components/splash_page.dart';
import 'package:Faleh_Hafez/presentation/home/search/search_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/group_profile/group_profile_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/login%20&%20register/login_page_chat.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/router_navbar_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/private_chats_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/pages/messenger_pages/public_chats_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/user_profile/edit_profile_page.dart';
import 'package:Faleh_Hafez/presentation/messenger/user_profile/profile_page.dart';
import 'package:Faleh_Hafez/presentation/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  setupLocator();

  // open box
  // ignore: unused_local_variable
  var box = await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // SignalRService().initConnection();

    return FutureBuilder(
      //

      future: Future.delayed(
        const Duration(seconds: 3),
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
                create: (context) => ChatThemeChangerBloc()
                  ..add(
                    FirstTimeOpenChat(),
                  ),
              ),
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
              // BlocProvider(
              //   create: (context) => GroupProfileBloc(),
              // ),

              // BlocProvider<MessagingBloc>(
              //   create: (context) =>
              //       sl<MessagingBloc>()..add(ConnectToSignalR()),
              // ),
              //! For Now (When I want navigate to homePage I have to delete this line)
              BlocProvider(
                create: (context) => ChatItemsBloc(),
              ),
              //! For Now (When I want navigate to homePage I have to delete this line)
            ],
            child: BlocBuilder<ThemeChangerBloc, ThemeChangerState>(
              builder: (context, state) {
                if (state is ThemeChangerLoading) {
                  return const MaterialApp(
                    debugShowCheckedModeBanner: false,
                    home: SplashPage(),
                  );
                }
                if (state is ThemeChangerLoaded) {
                  return MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: state.theme,
                    // home: const HomeChatsPage(),p
                    // home: const LoginPageMessenger(),
                    // home: const ProfilePage(),
                    // home: const GroupProfilePage(),
                    // home: const SearchPage(),
                    // home: const SplashPage(),
                    // home: const HomePage(),
                    // home: const AboutUsPage(),
                    home: const RouterNavbarPage(),
                    // home: const ProfilePage(),
                  );
                } else {
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
