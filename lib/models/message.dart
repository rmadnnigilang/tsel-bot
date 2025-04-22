import 'package:tsel_bot/models/product.dart';

enum MessageType { text, product }

class Message {
  final String from;
  final String text;
  final MessageType type;
  final Product? product;

  Message({
    required this.from,
    required this.text,
    this.type = MessageType.text,
    this.product,
  });
}
