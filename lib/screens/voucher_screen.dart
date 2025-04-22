import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/voucher_bloc/voucher_bloc.dart';
import '../blocs/voucher_bloc/voucher_event.dart';
import '../blocs/voucher_bloc/voucher_state.dart';
import '../widgets/vouchers/voucher_form_redeem.dart';
import '../widgets/vouchers/voucher_form_check.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoucherBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FBFC),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabbar Header
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Home (kanan atas)
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(top: 20, right: 20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FB),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.more_horiz,
                            size: 18,
                            color: Colors.black87,
                          ),
                          Container(
                            width: 1,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            color: Colors.black26,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.home_outlined,
                              size: 18,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Tabs
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: BlocBuilder<VoucherBloc, VoucherState>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            _buildTab(
                              context,
                              "Redeem Voucher",
                              0,
                              state.selectedTab,
                            ),
                            const SizedBox(width: 24),
                            _buildTab(
                              context,
                              "Cek Voucher",
                              1,
                              state.selectedTab,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(),

              // Tab Content
              Expanded(
                child: BlocBuilder<VoucherBloc, VoucherState>(
                  builder: (context, state) {
                    if (state.selectedTab == 0) {
                      return const VoucherFormRedeem();
                    } else {
                      return const VoucherCheckForm();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    String label,
    int index,
    int selectedIndex,
  ) {
    final isActive = index == selectedIndex;
    return GestureDetector(
      onTap: () => context.read<VoucherBloc>().add(SwitchVoucherTab(index)),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? const Color(0xFFD52222) : Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2,
            width: 100,
            color: isActive ? const Color(0xFFD52222) : Colors.transparent,
          ),
        ],
      ),
    );
  }
}
