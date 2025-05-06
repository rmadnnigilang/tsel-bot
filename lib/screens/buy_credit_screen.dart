// screens/buy_credit_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/buy_credit_blocs/buy_credit_bloc.dart';
import '../blocs/buy_credit_blocs/buy_credit_event.dart';
import '../blocs/buy_credit_blocs/buy_credit_state.dart';

class BuyCreditScreen extends StatefulWidget {
  const BuyCreditScreen({super.key});

  @override
  State<BuyCreditScreen> createState() => _BuyCreditScreenState();
}

class _BuyCreditScreenState extends State<BuyCreditScreen> {
  final _amountController = TextEditingController();
  String _selectedMethod = 'bank_transfer';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BuyCreditBloc(context),
      child: Scaffold(
        appBar: AppBar(title: const Text('Beli Pulsa')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Nominal (Rp)"),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedMethod,
                items: const [
                  DropdownMenuItem(
                    value: 'bank_transfer',
                    child: Text('Bank Transfer'),
                  ),
                  DropdownMenuItem(value: 'ewallet', child: Text('E-Wallet')),
                ],
                onChanged:
                    (val) => setState(() {
                      _selectedMethod = val!;
                    }),
                decoration: const InputDecoration(
                  labelText: "Metode Pembayaran",
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<BuyCreditBloc, BuyCreditState>(
                listener: (context, state) {
                  if (state is BuyCreditSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (state is BuyCreditFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is BuyCreditLoading) {
                    return const CircularProgressIndicator();
                  }

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final amount = int.tryParse(_amountController.text);
                        if (amount == null || amount <= 0) return;

                        context.read<BuyCreditBloc>().add(
                          SubmitBuyCredit(
                            amount: amount,
                            paymentMethod: _selectedMethod,
                          ),
                        );
                      },
                      child: const Text("Beli Pulsa"),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
