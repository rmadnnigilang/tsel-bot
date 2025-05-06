import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'profile_event.dart';
import 'profile_state.dart';
import 'package:flutter/foundation.dart'; // untuk debugPrint

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<FetchProfileData>(_onFetchProfile);
  }

  Future<void> _onFetchProfile(
    FetchProfileData event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      final response = await http.get(
        Uri.parse('https://llmcore.aspal.in/llm-demo-flask/v-1/user/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${event.token}',
        },
      );

      final data = jsonDecode(response.body);

      // ✅ Log seluruh data untuk debugging
      debugPrint("📦 Full Profile Response: ${jsonEncode(data)}");

      if (data['error'] == false) {
        final profile = data['data']['profile'];
        final history = data['data']['purchase_history'];
        final recommendation = data['data']['recommendations'];

        // ✅ Log bagian per bagian
        debugPrint("👤 Profile: ${jsonEncode(profile)}");
        debugPrint("🛒 History: ${jsonEncode(history)}");
        debugPrint("🎯 Recommendations: ${jsonEncode(recommendation)}");

        emit(
          ProfileLoaded(
            profile: profile,
            purchaseHistory: history,
            recommendations: recommendation,
          ),
        );
      } else {
        debugPrint("⚠️ Error dari server: ${data['message']}");
        emit(ProfileError("Gagal mengambil data profil"));
      }
    } catch (e) {
      debugPrint("❌ Exception: $e");
      emit(ProfileError("Terjadi kesalahan: ${e.toString()}"));
    }
  }
}
