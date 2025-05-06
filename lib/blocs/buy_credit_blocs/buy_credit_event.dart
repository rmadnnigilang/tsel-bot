abstract class BuyCreditEvent {}

class SubmitBuyCredit extends BuyCreditEvent {
  final int amount;
  final String paymentMethod;

  SubmitBuyCredit({required this.amount, required this.paymentMethod});
}
