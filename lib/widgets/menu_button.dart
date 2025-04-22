import 'package:flutter/material.dart';
import 'package:tsel_bot/screens/budget_package_screen.dart';
import 'package:tsel_bot/screens/voucher_screen.dart';
import '../screens/chat_bot_screen.dart';
import '../screens/featured_package_screen.dart';

class MenuButton extends StatelessWidget {
  final String title;

  const MenuButton({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      elevation: 1.5,
      shadowColor: Colors.black12,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          if (title == 'Bot') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ChatBotScreen()),
            );
          } else if (title == 'Buy Featured Package') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FeaturedPackageScreen()),
            );
          } else if (title == 'Buy Budget Package') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BudgetPackageScreen()),
            );
          } else if (title == 'Voucher Internet') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VoucherScreen()),
            );
          } else {
            // todo: handle navigasi lainnya
          }
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
