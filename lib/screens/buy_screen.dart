// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:tsel_bot/blocs/auth_cubit.dart';
// import '../blocs/buy_credit_blocs/buy_credit_bloc.dart';
// import '../blocs/buy_credit_blocs/buy_credit_event.dart';
// import '../blocs/buy_credit_blocs/buy_credit_state.dart';

// class BuyCreditScreen extends StatefulWidget {
//   const BuyCreditScreen({super.key});

//   @override
//   State<BuyCreditScreen> createState() => _BuyCreditScreenState();
// }

// class _BuyCreditScreenState extends State<BuyCreditScreen> {
//   final _amountController = TextEditingController();
//   String _paymentMethod = "bank_transfer";

//   String formatCurrency(int amount) {
//     return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(amount);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => BuyCreditBloc(context),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Beli Pulsa"),
//         ),
//         backgroundColor: const Color(0xFFEAF2FB),
//         body: Padding(
//           padding: const EdgeInsets.all(20),
//           child: BlocConsumer<BuyCreditBloc, BuyCreditState>(
//             listener: (context, state) {
//               if (state is BuyCreditSuccess) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message), backgroundColor: Colors.green),
//                 );
//                 _amountController.clear();
//               } else if (state is BuyCreditFailure) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message), backgroundColor: Colors.red),
//                 );
//               }
//             },
//             builder: (context, state) {
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Jumlah Pulsa", style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   TextField(
//                     controller: _amountController,
//                     keyboardType: TextInputType.number,
//                     decoration: const InputDecoration(
//                       hintText: "Masukkan jumlah pulsa",
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text("Metode Pembayaran", style: TextStyle(fontWeight: FontWeight.bold)),
//                   const SizedBox(height: 8),
//                   DropdownButtonFormField<String>(
//                     value: _paymentMethod,
//                     items: const [
//                       DropdownMenuItem(value: "bank_transfer", child: Text("Bank Transfer")),
//                       DropdownMenuItem(value: "e_wallet", child: Text("E-Wallet")),
//                       DropdownMenuItem(value: "pulsa", child: Text("Pulsa (Potong saldo)")),
//                     ],
//                     onChanged: (val) {
//                       setState(() => _paymentMethod = val!);
//                     },
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(),
//                       filled: true,
//                       fillColor: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: state is BuyCreditLoading
//                           ? null
//                           : () {
//                               final amount = int.tryParse(_amountController.text);
//                               if (amount == null || amount <= 0) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text("Jumlah tidak valid")),
//                                 );
//                                 return;
//                               }

//                               context.read<BuyCreditBloc>().add(
//                                     SubmitBuyCredit(
//                                       amount: amount,
//                                       paymentMethod: _paymentMethod,
//                                     ),
//                                   );
//                             },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF0A1D51),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       child: state is BuyCreditLoading
//                           ? const CircularProgressIndicator(color: Colors.white)
//                           : const Text("Beli Pulsa", style: TextStyle(color: Colors.white)),
//                     ),
//                   )
//                 ],
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
