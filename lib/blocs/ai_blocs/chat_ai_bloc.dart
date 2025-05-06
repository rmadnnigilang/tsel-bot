import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tsel_bot/blocs/ai_blocs/chat_ai_event.dart';
import 'package:tsel_bot/blocs/ai_blocs/chat_ai_state.dart';
import 'package:tsel_bot/blocs/auth_cubit.dart';
import '../../models/ai_message.dart';
import 'package:uuid/uuid.dart';

class ChatAIBloc extends Bloc<ChatAIEvent, ChatAIState> {
  final AuthCubit authCubit;
  final _uuid = Uuid();
  final String chatId = const Uuid().v4();
  final String sessionId = const Uuid().v4();

  ChatAIBloc({required this.authCubit})
    : super(
        ChatAIState(
          messages: [
            Message(
              from: 'bot',
              text:
                  'Halo! Saya AI Assistant. Ada yang bisa saya bantu hari ini? 😊',
            ),
          ],
          isTyping: false,
        ),
      ) {
    on<UserSendAIMessage>(_onUserSendMessage);
    on<SelectTag>((event, emit) {
      emit(state.copyWith(selectedTag: event.tag));
    });
  }

  String detectLanguageTag(String prompt) {
    final lowerPrompt = prompt.toLowerCase();

    // Kata khas bahasa Sunda
    final sundaneseWords = [
      'kuring',
      'teu',
      'mah',
      'sanes',
      'kumaha',
      'kanggo',
    ];

    // Kata khas bahasa Jawa
    final javaneseWords = ['aku', 'kowe', 'opo', 'kok', 'ngene', 'ora', 'kertu'];

    if (sundaneseWords.any((word) => lowerPrompt.contains(word))) {
      return 'sundanese';
    } else if (javaneseWords.any((word) => lowerPrompt.contains(word))) {
      return 'javanese';
    }

    // Default jika tidak cocok keduanya
    return 'indonesian';
  }

  String _getTagFromPrompt(String prompt, String? selectedTag) {
    final trimmed = prompt.trim();

    final isNumericSelection = RegExp(r'^[1-6]$').hasMatch(trimmed);

    if (isNumericSelection) {
      return 'buy-package';
    }

    return selectedTag ?? detectLanguageTag(prompt);
  }

  Future<void> _onUserSendMessage(
    UserSendAIMessage event,
    Emitter<ChatAIState> emit,
  ) async {
    final updatedMessages = List<Message>.from(state.messages)
      ..add(Message(from: 'user', text: event.prompt));

    emit(state.copyWith(messages: updatedMessages, isTyping: true));

    try {
      final user = authCubit.state;
      if (user == null) {
        emit(
          state.copyWith(
            isTyping: false,
            messages: [
              ...state.messages,
              Message(
                from: 'bot',
                text: 'Gagal membaca user. Coba login ulang.',
              ),
            ],
          ),
        );
        return;
      }

      final response = await http.post(
        Uri.parse('https://llm.aspal.in/llm-demo-flask/v-1/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "prompt": event.prompt,
          "chat_id": chatId,
          "session_id": sessionId,
          "user_id": user.userId,
          "tag": _getTagFromPrompt(event.prompt, state.selectedTag),
        }),
      );

      debugPrint("✅ [API Response Body]: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final aiMessage =
            data['ai'] ?? "Maaf, saya tidak bisa menjawab saat ini.";
        debugPrint("✅ [AI Response Body]: $aiMessage");

        // Hapus format markdown bold (**) dan tampilkan sebagai bubble biasa
        final cleanedText = aiMessage.replaceAll(RegExp(r'\*\*'), '').trim();

        updatedMessages.add(Message(from: 'bot', text: cleanedText));

        final tag = _getTagFromPrompt(event.prompt, state.selectedTag);

        // 🔍 Log tag yang dikirim
        debugPrint("📨 Tag yang dikirim ke API: $tag");

        // Deteksi apakah ada pilihan produk berdasarkan angka
        final hasNumberedList = RegExp(
          r'^1\.\s.+$',
          multiLine: true,
        ).hasMatch(aiMessage);

        if (hasNumberedList) {
          updatedMessages.add(
            Message(
              from: 'bot',
              text:
                  '💡 Ingin beli salah satu produk di atas? Cukup ketik angka 1 - 6 sesuai urutan produk yang ingin kamu pilih.',
            ),
          );
        }

        emit(state.copyWith(messages: updatedMessages, isTyping: false));
      } else {
        updatedMessages.add(
          Message(
            from: 'bot',
            text: '⚠️ Gagal mendapatkan respon dari AI. Coba lagi nanti.',
          ),
        );
        emit(state.copyWith(messages: updatedMessages, isTyping: false));
      }
    } catch (e) {
      updatedMessages.add(
        Message(
          from: 'bot',
          text: '❌ Terjadi kesalahan. Pastikan koneksi internet stabil.',
        ),
      );
      emit(state.copyWith(messages: updatedMessages, isTyping: false));
    }
  }
}
