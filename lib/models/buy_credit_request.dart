// models/buy_credit_request.dart
class BuyCreditRequest {
  final int amount;
  final String paymentMethod;

  BuyCreditRequest({required this.amount, required this.paymentMethod});

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "payment_method": paymentMethod,
  };
}
