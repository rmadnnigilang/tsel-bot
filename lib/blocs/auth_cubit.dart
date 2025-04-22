import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class AuthCubit extends Cubit<User?> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository}) : super(null);

  Future<void> login(String msisdn) async {
    try {
      final user = await authRepository.login(msisdn);
      emit(user);
    } catch (e) {
      emit(null);
      rethrow;
    }
  }

  void logout() => emit(null);
}
