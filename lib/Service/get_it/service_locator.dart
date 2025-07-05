import 'package:faleh_hafez/Service/signal_r/SignalR_Service.dart';
import 'package:get_it/get_it.dart';
import 'package:faleh_hafez/application/messaging/bloc/messaging_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  // sl.registerLazySingleton<SignalRService>(() => SignalRService());

  // sl.registerFactory<MessagingBloc>(() => MessagingBloc());
}
