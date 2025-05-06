import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsel_bot/repositories/auth_repository.dart';
import 'blocs/auth_cubit.dart';
import 'screens/home_screen.dart';
import 'repositories/menu_repository.dart';
import 'package:intl/date_symbol_data_local.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('id_ID', null);

  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    final menuRepository = MenuRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthCubit(authRepository: AuthRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Tsel Bot',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,

        navigatorObservers: [routeObserver],

        home: HomeScreen(menuRepository: menuRepository),
      ),
    );
  }
}
