import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/message.dart';
import '../../models/product.dart';
import '../../screens/payment_screen.dart';
import 'bot_event.dart';
import 'bot_state.dart';
import 'conversation_step.dart';

class BotBloc extends Bloc<BotEvent, BotState> {
  BotBloc()
    : super(
        BotState(
          messages: [
            Message(
              from: 'bot',
              text: 'Halo! Ada yang bisa saya bantu hari ini?',
            ),
          ],
          isTyping: false,
        ),
      ) {
    on<UserMessageSent>(_onMessageReceived);

    on<TopicSelected>((event, emit) {
      final updatedMessages = List<Message>.from(state.messages)
        ..add(Message(from: 'bot', text: "Topik percakapan: ${event.topic}"));

      emit(
        state.copyWith(selectedTopic: event.topic, messages: updatedMessages),
      );
    });
  }

  final List<Product> allProducts = [
    Product(name: "Streaming 15GB", description: "7 hari aktif", price: 40000),
    Product(name: "Streaming Unlimited", description: "7 hari", price: 75000),
    Product(
      name: "Combo 20GB + Telp",
      description: "Combo paket",
      price: 55000,
    ),
  ];

  final List<String> paymentMethods = ['Dana', 'Pulsa', 'Gopay'];

  Future<void> _onMessageReceived(
    UserMessageSent event,
    Emitter<BotState> emit,
  ) async {
    final input = event.message.toLowerCase();
    final messages = List<Message>.from(state.messages)
      ..add(Message(from: 'user', text: event.message));

    // Tampilkan status mengetik...
    emit(state.copyWith(messages: messages, isTyping: true));

    await Future.delayed(const Duration(milliseconds: 700)); // delay responsif

    ConversationStep step = state.step;

    switch (step) {
      case ConversationStep.idle:
        messages.add(
          Message(
            from: 'bot',
            text: "Oke, kamu cari paket apa? (hemat, streaming, promo)",
          ),
        );
        emit(
          state.copyWith(
            messages: messages,
            step: ConversationStep.choosingCategory,
            isTyping: false,
          ),
        );
        break;

      case ConversationStep.choosingCategory:
        String category = input.contains("stream") ? "streaming" : input;
        final products =
            allProducts
                .where((p) => p.name.toLowerCase().contains(category))
                .toList();

        if (products.isEmpty) {
          messages.add(
            Message(
              from: 'bot',
              text: "Maaf, belum ada produk untuk \"$input\" 😅",
            ),
          );
        } else {
          messages.add(Message(from: 'bot', text: "Berikut pilihannya:"));
          for (var p in products) {
            messages.add(
              Message(
                from: 'bot',
                text: '', 
                type: 'card',
              ),
            );
          }
          messages.add(
            Message(
              from: 'bot',
              text: "Silakan ketik nama produk yang kamu pilih",
            ),
          );
        }

        emit(
          state.copyWith(
            messages: messages,
            step: ConversationStep.choosingProduct,
            selectedCategory: category,
            isTyping: false,
          ),
        );
        break;

      case ConversationStep.choosingProduct:
        final selected = allProducts.firstWhere(
          (p) => p.name.toLowerCase().contains(input),
          orElse: () => Product(name: '', description: '', price: 0),
        );

        if (selected.name.isEmpty) {
          messages.add(
            Message(
              from: 'bot',
              text: "Produk tidak ditemukan. Coba ketik ulang ya.",
            ),
          );
        } else {
          messages.add(
            Message(
              from: 'bot',
              text:
                  "Metode pembayaran apa yang kamu mau? (Dana / Pulsa / Gopay)",
            ),
          );
          emit(
            state.copyWith(
              messages: messages,
              step: ConversationStep.choosingPayment,
              selectedProduct: selected,
              isTyping: false,
            ),
          );
          return;
        }

        emit(state.copyWith(messages: messages, isTyping: false));
        break;

      case ConversationStep.choosingPayment:
        final selectedPayment = paymentMethods.firstWhere(
          (p) => input.contains(p.toLowerCase()),
          orElse: () => '',
        );

        if (selectedPayment.isEmpty) {
          messages.add(
            Message(
              from: 'bot',
              text:
                  "Metode pembayaran tidak dikenali. Coba ketik: Dana, Pulsa, atau Gopay",
            ),
          );
          emit(state.copyWith(messages: messages, isTyping: false));
        } else {
          messages.add(
            Message(
              from: 'bot',
              text: "Sip! Sedang menyiapkan halaman pembayaran...",
            ),
          );
          emit(
            state.copyWith(
              messages: messages,
              step: ConversationStep.confirming,
              selectedPayment: selectedPayment,
              isTyping: false,
            ),
          );

          await Future.delayed(const Duration(seconds: 1));
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => PaymentScreen(product: state.selectedProduct!),
            ),
          );

          emit(state.copyWith(step: ConversationStep.done));
        }
        break;

      default:
        messages.add(
          Message(
            from: 'bot',
            text: "Sesi sudah selesai. Ketik sesuatu untuk mulai ulang 😄",
          ),
        );
        emit(
          state.copyWith(
            messages: messages,
            step: ConversationStep.idle,
            isTyping: false,
          ),
        );
    }
  }
}
