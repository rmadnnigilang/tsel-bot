import 'package:tsel_bot/models/ai_product.dart';

class Message {
  final String from;
  final String text;
  final String? type;
  final Product? product;

  Message({
    required this.from,
    required this.text,
    this.type,
    this.product,
  });
}
