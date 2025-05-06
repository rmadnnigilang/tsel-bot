// blocs/buy_credit/buy_credit_state.dart
abstract class BuyCreditState {}

class BuyCreditInitial extends BuyCreditState {}

class BuyCreditLoading extends BuyCreditState {}

class BuyCreditSuccess extends BuyCreditState {
  final String message;
  BuyCreditSuccess(this.message);
}

class BuyCreditFailure extends BuyCreditState {
  final String error;
  BuyCreditFailure(this.error);
}
