import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'buy_credit_event.dart';
import 'buy_credit_state.dart';
import 'package:flutter/material.dart';
import 'package:tsel_bot/blocs/auth_cubit.dart';

class BuyCreditBloc extends Bloc<BuyCreditEvent, BuyCreditState> {
  BuyCreditBloc(BuildContext context) : super(BuyCreditInitial()) {
    on<SubmitBuyCredit>((event, emit) async {
      emit(BuyCreditLoading());

      try {
        final authCubit = BlocProvider.of<AuthCubit>(context);
        final token = authCubit.state?.token;

        if (token == null) {
          emit(BuyCreditFailure("Token tidak ditemukan. Silakan login ulang."));
          return;
        }

        final response = await http.post(
          Uri.parse('https://llmcore.aspal.in/llm-demo-flask/v-1/buy-credit'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'amount': event.amount,
            'payment_method': event.paymentMethod,
          }),
        );

        if (response.statusCode == 200) {
          emit(BuyCreditSuccess("Pembelian berhasil!"));
        } else {
          emit(BuyCreditFailure("Gagal membeli pulsa: ${response.statusCode}"));
        }
      } catch (e) {
        emit(BuyCreditFailure("Terjadi kesalahan: $e"));
      }
    });
  }
}
