import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<bool> {
  AuthCubit() : super(false); // default: belum login

  void login() => emit(true);
  void logout() => emit(false);
}
