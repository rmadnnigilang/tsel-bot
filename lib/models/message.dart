enum MessageType { text, product }

class Message {
  final String from;
  final String text;
  final String? type; // tambahkan ini

  Message({required this.from, required this.text, this.type});
}
