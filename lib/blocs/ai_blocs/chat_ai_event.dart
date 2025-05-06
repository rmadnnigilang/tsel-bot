abstract class ChatAIEvent {}

class UserSendAIMessage extends ChatAIEvent {
  final String prompt;
  UserSendAIMessage(this.prompt);
}

class SelectTag extends ChatAIEvent {
  final String tag;
  SelectTag(this.tag);
}

