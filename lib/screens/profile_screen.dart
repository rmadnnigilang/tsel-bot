import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tsel_bot/blocs/auth_cubit.dart';
import 'package:tsel_bot/models/user_model.dart';
import '../blocs/profile_blocs/profile_bloc.dart';
import '../blocs/profile_blocs/profile_event.dart';
import '../blocs/profile_blocs/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  String formatCurrency(num amount) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }
  

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state;

    return BlocProvider(
      create: (_) => ProfileBloc()..add(FetchProfileData(user?.token ?? '')),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F8FB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0A1D51),
                  Color(0xFF1B1F60),
                  Color(0xFFB5102A),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text(
                'Profil Saya',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: false,
            ),
          ),
        ),
        body: BlocListener<AuthCubit, User?>(
          listener: (context, state) {
            if (state != null) {
              // If the user is logged in (state is not null), refetch profile data
              context.read<ProfileBloc>().add(FetchProfileData(state.token));
            }
          },
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (user?.token == null || user!.token.isEmpty) {
                return const Center(
                  child: Text('Token tidak tersedia. Silakan login ulang.'),
                );
              }
              if (state is ProfileError) {
                return Center(child: Text(state.message));
              }

              if (state is ProfileLoaded) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildHeader(state.profile),
                    const SizedBox(height: 16),
                    _buildQuickInfoCard(state.profile),
                    const SizedBox(height: 24),
                    _buildSectionTitle("Riwayat Pembelian"),
                    ...state.purchaseHistory.map(_buildPurchaseItem).toList(),
                    const SizedBox(height: 24),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Map<String, dynamic> profile) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 30,
          backgroundImage: AssetImage('assets/images/bot_avatar.png'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                profile['location'],
                style: const TextStyle(color: Colors.black54),
              ),
              Text(profile['msisdn'], style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickInfoCard(Map<String, dynamic> profile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _infoTile("Level", profile['level']),
          _infoTile(
            "Pulsa",
            formatCurrency(num.tryParse(profile['pulsa'].toString()) ?? 0),
          ),
          _infoTile("Kuota", "${profile['remaining_quota']} GB"),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          title,
          style: const TextStyle(color: Colors.black54, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildPurchaseItem(dynamic item) {
    DateTime? purchaseDate;
    try {
      // Parse ISO 8601 format langsung
      purchaseDate = DateTime.parse(item['timestamp']).toLocal();
    } catch (e) {
      purchaseDate = null;
    }

    final formattedDate =
        purchaseDate != null
            ? DateFormat("d MMMM yyyy", 'id_ID').format(purchaseDate)
            : "Tanggal tidak tersedia";

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 4),
      title: Text(
        item['package_name'],
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Rp${item['amount']} - ${item['duration']} hari"),
          const SizedBox(height: 4),
          Text(
            "Dibeli pada: $formattedDate",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("${item['quota']} GB"),
          Text(
            item['payment_method'],
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
