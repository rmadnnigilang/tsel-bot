abstract class BotEvent {}

class UserMessageSent extends BotEvent {
  final String message;
  UserMessageSent(this.message);
}

class TopicSelected extends BotEvent {
  final String topic;
  TopicSelected(this.topic);
}

class ShowAllProductsPressed extends BotEvent {}
