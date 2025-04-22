import '../../models/message.dart';
import '../../models/product.dart';
import 'conversation_step.dart';

class BotState {
  final List<Message> messages;
  final ConversationStep step;
  final String? selectedCategory;
  final Product? selectedProduct;
  final String? selectedPayment;
  final bool isTyping;
  final String? selectedTopic;

  BotState({
    this.messages = const [],
    this.step = ConversationStep.idle,
    this.selectedCategory,
    this.selectedProduct,
    this.selectedPayment,
    this.isTyping = false,
    this.selectedTopic,
  });

  BotState copyWith({
    List<Message>? messages,
    ConversationStep? step,
    String? selectedCategory,
    Product? selectedProduct,
    String? selectedPayment,
    bool? isTyping,
    String? selectedTopic,
  }) {
    return BotState(
      messages: messages ?? this.messages,
      step: step ?? this.step,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      selectedPayment: selectedPayment ?? this.selectedPayment,
      isTyping: isTyping ?? this.isTyping,
      selectedTopic: selectedTopic ?? this.selectedTopic,
    );
  }
}
