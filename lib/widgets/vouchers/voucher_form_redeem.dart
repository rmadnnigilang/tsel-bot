import 'package:flutter/material.dart';

class VoucherFormRedeem extends StatelessWidget {
  const VoucherFormRedeem({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gosok voucher dan masukan 17 digit kode voucher di balik hologram",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          const Text("Jenis Voucher", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Row(
            children: const [
              Radio(value: true, groupValue: true, onChanged: null),
              Text("Voucher Fisik"),
              SizedBox(width: 16),
              Radio(value: false, groupValue: true, onChanged: null),
              Text("E-Voucher"),
            ],
          ),
          const SizedBox(height: 14),
          const Text("Nomor Telkomsel", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: "Masukkan Nomor Telkomsel Anda",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 14),
          const Text("Kode Voucher", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            decoration: InputDecoration(
              hintText: "Masukkan Kode Voucher",
              suffixIcon: const Icon(Icons.info_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text("Redeem"),
          ),
          const SizedBox(height: 24),
          const Text.rich(
            TextSpan(
              text: "Dengan melakukan pemesanan ini, Anda patuh terhadap ",
              children: [
                TextSpan(
                  text: "kebijakan privasi",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                TextSpan(text: " serta "),
                TextSpan(
                  text: "syarat dan ketentuan",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                TextSpan(text: " yang berlaku di Telkomsel."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
