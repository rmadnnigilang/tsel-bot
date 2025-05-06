import '../../models/ai_message.dart';

class ChatAIState {
  final List<Message> messages;
  final bool isTyping;
  final String? selectedTag;

  ChatAIState({required this.messages, required this.isTyping, this.selectedTag,});

  ChatAIState copyWith({List<Message>? messages, bool? isTyping, String? selectedTag,}) {
    return ChatAIState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      selectedTag: selectedTag ?? this.selectedTag,
    );
  }
}
