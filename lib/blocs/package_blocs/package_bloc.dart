import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../models/internet_package.dart';
import 'package_event.dart';
import 'package_state.dart';

class PackageBloc extends Bloc<PackageEvent, PackageState> {
  final String token;

  PackageBloc(this.token) : super(PackageInitial()) {
    on<FetchPackages>(_onFetch);
    on<BuyPackage>(_onBuy);
  }

  Future<void> _onFetch(FetchPackages event, Emitter<PackageState> emit) async {
    // Menandakan bahwa data sedang dimuat
    emit(PackageLoading());

    try {
      final response = await http.get(
        Uri.parse(
          'https://llmcore.aspal.in/llm-demo-flask/v-1/packages?category_id=2&page=${event.page}&limit=${event.limit}',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      // Pastikan response statusCode 200 sebelum melanjutkan parsing JSON
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Pastikan format data sesuai yang diharapkan
        if (jsonData['error'] == false &&
            jsonData['data'] != null &&
            jsonData['data']['packages'] != null) {
          final data = jsonData['data']['packages'] as List;
          final packages =
              data.map((e) => InternetPackage.fromJson(e)).toList();

          // Menangani informasi pagination
          final currentPage = jsonData['data']['current_page'] ?? 1;
          final totalPages = jsonData['data']['total_pages'] ?? 1;

          // Emit PackageLoaded setelah data berhasil diterima
          emit(
            PackageLoaded(
              packages: packages,
              currentPage: currentPage,
              totalPages: totalPages,
            ),
          );
        } else {
          emit(PackageError("Data paket tidak ditemukan."));
        }
      } else {
        emit(
          PackageError(
            "Gagal mengambil data paket dengan status: ${response.statusCode}",
          ),
        );
      }
    } catch (e) {
      emit(PackageError("Gagal mengambil data paket: $e"));
    }
  }

  Future<void> _onBuy(BuyPackage event, Emitter<PackageState> emit) async {
    emit(PackageBuying());
    try {
      final response = await http.post(
        Uri.parse('https://llmcore.aspal.in/llm-demo-flask/v-1/buy-package'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "package_id": event.packageId,
          "payment_method": event.paymentMethod,
        }),
      );

      final json = jsonDecode(response.body);
      if (json['error'] == false) {
        emit(PackageBought("Paket berhasil dibeli!"));
      } else {
        emit(PackageError("Pembelian gagal: ${json['message']}"));
      }
    } catch (e) {
      emit(PackageError("Terjadi kesalahan: $e"));
    }
  }
}
