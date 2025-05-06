import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsel_bot/blocs/ai_blocs/chat_ai_bloc.dart';
import 'package:tsel_bot/blocs/ai_blocs/chat_ai_event.dart';
import 'package:tsel_bot/blocs/ai_blocs/chat_ai_state.dart';
import 'package:tsel_bot/blocs/auth_cubit.dart';
import 'package:tsel_bot/models/ai_product.dart';
import 'package:tsel_bot/screens/payment_screen.dart';
import '../../models/ai_message.dart';
import 'package:intl/intl.dart';

class ChatWithAIScreen extends StatelessWidget {
  const ChatWithAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatAIBloc(authCubit: context.read<AuthCubit>()),
      child: const _ChatWithAIView(),
    );
  }
}

class _ChatWithAIView extends StatefulWidget {
  const _ChatWithAIView();

  @override
  State<_ChatWithAIView> createState() => _ChatWithAIViewState();
}

class _ChatWithAIViewState extends State<_ChatWithAIView> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  void _send(String text) {
    if (text.trim().isEmpty) return;
    context.read<ChatAIBloc>().add(UserSendAIMessage(text));
    _controller.clear();
    _autoScrollToBottom();
  }

  void _autoScrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF2FB),
      body: Column(
        children: [
          _buildHeader(),
          _buildChatBody(),
          _buildSelectedTagBadge(),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A1D51), Color(0xFF1B1F60), Color(0xFFE50914)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          ClipOval(
            child: Image.asset(
              'assets/images/bot_avatar.png',
              width: 36,
              height: 36,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "AI Assistant",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Chat with Masic",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopicOptions() {
    return BlocBuilder<ChatAIBloc, ChatAIState>(
      builder: (context, state) {
        if (state.selectedTag != null) return const SizedBox.shrink();

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Tentukan topik untuk percakapan yang lebih terarah, atau langsung mulai chat 💬",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              _buildTopicRow(
                context,
                title: "Rekomendasi",
                description: "Temukan produk yang pas buat kamu!",
                icon: Icons.star_border,
                onTap:
                    () => context.read<ChatAIBloc>().add(
                      SelectTag("rekomendasi"),
                    ),
              ),
              const Divider(height: 28, thickness: 0.8),
              _buildTopicRow(
                context,
                title: "FAQ",
                description: "Tanya seputar layanan atau bantuan teknis",
                icon: Icons.question_answer_outlined,
                onTap: () => context.read<ChatAIBloc>().add(SelectTag("faq")),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatBody() {
    return Expanded(
      child: BlocBuilder<ChatAIBloc, ChatAIState>(
        builder: (context, state) {
          final messages = state.messages;
          final isTyping = state.isTyping;
          final showTopicOptions = state.selectedTag == null;

          final totalItems = messages.length + (isTyping ? 1 : 0);

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            itemCount: totalItems + (showTopicOptions ? 1 : 0),
            itemBuilder: (context, index) {
              if (showTopicOptions && index == 0) {
                return _buildTopicOptions(); // Display at the start of the list
              }

              final adjustedIndex = index - (showTopicOptions ? 1 : 0);

              if (isTyping && adjustedIndex == messages.length) {
                return const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      "AI sedang mengetik...",
                      style: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                );
              }

              if (adjustedIndex < 0 || adjustedIndex >= messages.length) {
                return const SizedBox.shrink();
              }

              final msg = messages[adjustedIndex];
              return _buildChatBubble(msg); // Regular message bubble
            },
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PaymentScreen(product: product)),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xfff70a0b),
              ),
            ),
            const SizedBox(height: 6),
            Text(product.description, style: const TextStyle(fontSize: 13)),
            const SizedBox(height: 10),
            Text(
              "Rp${product.price?.toStringAsFixed(0) ?? '...'}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentScreen(product: product),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A1D51),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  "Beli",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTagBadge() {
    return BlocBuilder<ChatAIBloc, ChatAIState>(
      builder: (context, state) {
        if (state.selectedTag == null) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('Topik percakapan:'),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0A1D51), Color(0xFFE50914)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  state.selectedTag!,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () {
                  context.read<ChatAIBloc>().add(SelectTag(""));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChatBubble(Message msg) {
    final isUser = msg.from == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 280),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF0A1D51) : Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          msg.text,
          style: TextStyle(color: isUser ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: _send,
              textInputAction: TextInputAction.send,
              decoration: InputDecoration(
                hintText: "Tulis pertanyaan...",
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                filled: true,
                fillColor: const Color(0xFFF4F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.send_rounded, color: Color(0xFF0A1D51)),
            onPressed: () => _send(_controller.text),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicRow(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color.fromARGB(255, 243, 243, 243),
            ),
            child: Icon(icon, size: 18, color: const Color(0xfff70a0b)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xfff70a0b),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
