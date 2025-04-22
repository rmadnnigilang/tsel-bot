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
    Product(
      name: "Internet Super Seru",
      description: "10 GB | 28 hari",
      price: 28000,
      label: "Best Deal 🔥",
      kuota: "10 GB kuota utama",
      masaAktif: "Masa aktif 28 hari",
      category: "promo",
    ),
    Product(
      name: "SurpriseDeal Internet",
      description: "14 GB | 30 hari",
      price: 50000,
      label: "Lagi Promo!! 🎉",
      kuota: "10 GB kuota utama",
      masaAktif: "Masa aktif 30 hari",
      category: "promo",
    ),
    Product(
      name: "Internet Malam Extra",
      description: "20 GB | 30 hari",
      price: 45000,
      label: "Lagi Promo!! 🎉",
      kuota: "15 GB kuota utama",
      masaAktif: "Masa aktif 30 hari",
      category: "promo",
    ),

    Product(
      name: "Combo Seru Unlimited",
      description: "12 GB + Telp | 30 hari",
      price: 60000,
      label: "Best Deal 🔥",
      kuota: "12 GB kuota utama",
      masaAktif: "Masa aktif 30 hari",
      category: "promo",
    ),

    Product(
      name: "Streaming Max HD",
      description: "25 GB | 30 hari",
      price: 70000,
      label: "Rekomendasi 🎬",
      kuota: "25 GB untuk YouTube & Netflix",
      masaAktif: "Masa aktif 30 hari",
      category: "promo",
    ),

    Product(
      name: "Internet Ekstra Hemat",
      description: "8 GB | 14 hari",
      price: 20000,
      label: "Hemat Banget 💡",
      kuota: "8 GB kuota utama",
      masaAktif: "Masa aktif 14 hari",
      category: "promo",
    ),
  ];

  final List<String> paymentMethods = ['Dana', 'Pulsa', 'Gopay'];

  Future<void> _onMessageReceived(
    UserMessageSent event,
    Emitter<BotState> emit,
  ) async {
    final input = event.message.toLowerCase();
    final messages =
        List<Message>.from(state.messages)
          ..removeWhere((m) => m.type == MessageType.product)
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
        String category = input;
        if (input.contains("promo")) category = "promo";
        if (input.contains("stream")) category = "streaming";
        if (input.contains("hemat")) category = "hemat";

        final products =
            allProducts
                .where((p) => p.category.toLowerCase().contains(category))
                .toList();

        if (products.isEmpty) {
          messages.add(
            Message(
              from: 'bot',
              text: "Maaf, belum ada produk untuk \"$input\" 😅",
            ),
          );
        } else {
          messages.add(
            Message(
              from: 'bot',
              text:
                  "Rekomendasi ini aku sesuaikan sama kebiasaan kamu loh! 😉\n\n"
                  "• Harga favoritmu: Rp20rb–Rp100rb\n"
                  "• Kuota yang sering dipilih: 10–80 GB\n"
                  "• Lokasi: Bandung\n"
                  "• Kamu udah di level Silver 🎉",
            ),
          );

          for (var p in products) {
            messages.add(
              Message(
                from: 'bot',
                text: '',
                type: MessageType.product,
                product: p,
              ),
            );
          }
          // messages.add(
          //   Message(
          //     from: 'bot',
          //     text: "Silakan ketik nama produk yang kamu pilih",
          //   ),
          // );
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
          orElse:
              () => Product(
                name: '',
                description: '',
                price: 0,
                label: '',
                kuota: '',
                masaAktif: '',
                category: '',
              ),
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
    on<ShowAllProductsPressed>((event, emit) {
      emit(state.copyWith(isShowingAllProducts: true));
    });
  }
}
