import 'package:flutter/material.dart';
import '../models/budget_package.dart';

class BudgetPackageItem extends StatelessWidget {
  final BudgetPackage package;

  const BudgetPackageItem({super.key, required this.package});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9FBFC), Color(0xFFEFF3F9)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Paket
            Text(
              package.name,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            const SizedBox(height: 6),

            // Benefit dan masa aktif
            Text(
              "${package.benefit} | ${package.validity}",
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Label Nonton
            const Text(
              "Nonton",
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),

            // Kuota
            Text(
              package.benefit,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      package.provider,
                      style: const TextStyle(fontSize: 13),
                      overflow: TextOverflow.ellipsis, // jika terlalu panjang
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    package.validity,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 16),
                ],
              ),
            ),

            const Spacer(),

            // Harga
            Text(
              "Rp. ${package.price.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}",
              style: const TextStyle(
                color: Color(0xFFD52222),
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
