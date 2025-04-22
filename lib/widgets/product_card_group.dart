import 'package:flutter/material.dart';

class ProductCardGroup extends StatelessWidget {
  const ProductCardGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Expanded(
              child: _ProductCard(
                tag: "Best Deal 🔥",
                title: "Super Seru",
                quota: "10 GB",
                duration: "28 hari",
                price: "Rp28.000",
                features: [
                  "10 GB kuota utama",
                  "Masa aktif 28 hari",
                ],
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _ProductCard(
                tag: "Lagi Promo!! 🎉",
                title: "SurpriseDeal Internet",
                quota: "14 GB",
                duration: "30 hari",
                price: "Rp50.000",
                features: [
                  "10 GB kuota utama",
                  "Masa aktif 30 hari",
                  "Bonus 5 GB kuota bonus",
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // Lihat semua produk
          },
          child: const Text(
            "Lihat Semua Produk",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        )
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String tag;
  final String title;
  final String quota;
  final String duration;
  final String price;
  final List<String> features;

  const _ProductCard({
    required this.tag,
    required this.title,
    required this.quota,
    required this.duration,
    required this.price,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFf70a0b),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tag,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(
                  fontSize: 14.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("$quota | $duration",
              style: const TextStyle(
                  fontSize: 13.5, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(price,
              style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xfff70a0b))),
          const SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: features
                .map((f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              size: 14, color: Colors.green),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(f,
                                style: const TextStyle(fontSize: 12.5)),
                          )
                        ],
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xfff70a0b),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size.fromHeight(36),
            ),
            child: const Text("Beli Paket"),
          )
        ],
      ),
    );
  }
}
