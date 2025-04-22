import 'package:flutter/material.dart';

class VoucherCheckForm extends StatefulWidget {
  const VoucherCheckForm({super.key});

  @override
  State<VoucherCheckForm> createState() => _VoucherCheckFormState();
}

class _VoucherCheckFormState extends State<VoucherCheckForm> {
  final TextEditingController _serialController = TextEditingController();
  bool isVoucherPhysical = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Masukkan 12 digit nomor seri yang tertera di atas barcode pada voucher",
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 16),

          const Text(
            "Jenis Voucher",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
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

          const SizedBox(height: 12),
          const Text(
            "Nomor Seri",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _serialController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "Masukkan Kode Voucher",
              suffixIcon: const Icon(Icons.wallet, color: Color(0xFF0A1D51)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Implementasi pengecekan voucher di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Cek Voucher",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text.rich(
            TextSpan(
              text: "Dengan melakukan pemesanan ini, Anda patuh terhadap ",
              children: [
                TextSpan(
                  text: "kebijakan privasi",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: " serta "),
                TextSpan(
                  text: "syarat dan ketentuan",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextSpan(text: " yang berlaku di Telkomsel."),
              ],
            ),
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}
