import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tsel_bot/blocs/bot_blocs/bot_bloc.dart';
import 'package:tsel_bot/blocs/bot_blocs/bot_event.dart';
import 'package:tsel_bot/blocs/bot_blocs/bot_state.dart';
import 'package:tsel_bot/blocs/bot_blocs/conversation_step.dart';
import '../models/message.dart';

class ChatBotScreen extends StatelessWidget {
  const ChatBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => BotBloc(), child: const _ChatBotView());
  }
}

class _ChatBotView extends StatefulWidget {
  const _ChatBotView();

  @override
  State<_ChatBotView> createState() => _ChatBotViewState();
}

class _ChatBotViewState extends State<_ChatBotView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _send(String text) {
    if (text.trim().isEmpty) return;
    context.read<BotBloc>().add(UserMessageSent(text));
    _controller.clear();

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
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xffff9706),
                  Color(0xfff70a0b),
                  Color(0xffd40312),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                // Avatar bot
                ClipOval(
                  child: Image.asset(
                    'assets/images/bot_avatar.png',
                    width: 36,
                    height: 36,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                // Teks nama dan jabatan
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "T-Bot",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Virtual Assistant",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Chat body
          Expanded(
            child: BlocBuilder<BotBloc, BotState>(
              builder: (context, state) {
                final messages = state.messages;
                final isTyping = state.isTyping;
                final showTopicOptions =
                    messages.length == 1 && state.selectedTopic == null;

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  itemCount:
                      messages.length +
                      (isTyping ? 1 : 0) +
                      (showTopicOptions ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (showTopicOptions && index == 1) {
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
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            _buildTopicRow(
                              context,
                              title: "Rekomendasi",
                              description: "Temukan produk yang pas buat kamu!",
                              icon: Icons.star_border,
                              onTap:
                                  () => context.read<BotBloc>().add(
                                    TopicSelected("Rekomendasi"),
                                  ),
                            ),
                            const Divider(
                              height: 28,
                              thickness: 0.8,
                              color: Color(0xFFE5E7EB),
                            ),
                            _buildTopicRow(
                              context,
                              title: "FAQ",
                              description:
                                  "Tanya seputar produk dan layanan Telkomsel",
                              icon: Icons.question_answer_outlined,
                              onTap:
                                  () => context.read<BotBloc>().add(
                                    TopicSelected("FAQ"),
                                  ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (isTyping && index == messages.length) {
                      return const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 6),
                          child: Text(
                            "Tsel Bot sedang mengetik...",
                            style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      );
                    }

                    final msg = messages[index];
                    final isUser = msg.from == 'user';

                    if (msg.type == 'card') {
                      final parts = msg.text.split('|');
                      if (parts.length >= 3) {
                        return _buildProductCard(
                          title: parts[0],
                          description: parts[1],
                          price: parts[2],
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            '⚠️ Format produk tidak valid.',
                            style: TextStyle(color: Colors.red),
                          ),
                        );
                      }
                    }

                    return Align(
                      alignment:
                          isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color:
                              isUser
                                  ? const Color.fromARGB(255, 247, 10, 10)
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            color: isUser ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Tag topik percakapan
          BlocBuilder<BotBloc, BotState>(
            builder: (context, state) {
              if (state.selectedTopic == null || state.selectedTopic!.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Topik percakapan:',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xffff9706), Color(0xfff70a0b)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            state.selectedTopic!,
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
                            context.read<BotBloc>().add(TopicSelected(''));
                          },
                        ),
                      ],
                    ),
                    const Divider(
                      color: Color(0xFFE5E7EB),
                      height: 24,
                      thickness: 1,
                    ),
                  ],
                ),
              );
            },
          ),

          // Input field
          Container(
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
                      hintText: "Tulis pesan...",
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
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Color(0xFF0A1D51),
                  ),
                  onPressed: () => _send(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String title,
    required String description,
    required String price,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dan badge promo
          Row(
            children: const [
              Text(
                "Best Deal 🔥",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                "Promo!",
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Nama paket
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          // Deskripsi
          Text(description),
          const SizedBox(height: 6),
          // Harga
          Text(
            "Rp$price",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          // Tombol beli
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff70a0b),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text("Beli Paket"),
            ),
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
              color: const Color(0xFFFEE2E2),
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
