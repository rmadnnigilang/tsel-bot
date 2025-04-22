import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/auth_cubit.dart';
import 'screens/home_screen.dart';
import 'repositories/menu_repository.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    final menuRepository = MenuRepository();

    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => AuthCubit())],
      child: MaterialApp(
        title: 'Tsel Bot',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        home: HomeScreen(menuRepository: menuRepository),
      ),
    );
  }
}
