import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/budget_package.dart';
import 'budget_package_event.dart';
import 'budget_package_state.dart';

class BudgetPackageBloc extends Bloc<BudgetPackageEvent, BudgetPackageState> {
  BudgetPackageBloc() : super(BudgetPackageLoading()) {
    on<LoadBudgetPackages>((event, emit) async {
      // Simulasi loading 1 detik
      await Future.delayed(const Duration(seconds: 1));

      final dummy = [
        BudgetPackage(
          name: "Nonton Hemat 5000",
          validity: "30 Days",
          benefit: "1 GB",
          price: 5000,
          provider: "Catchplay+",
        ),
        BudgetPackage(
          name: "Nonton Hemat 10000",
          validity: "30 Days",
          benefit: "1 GB",
          price: 10000,
          provider: "Vidio Gold",
        ),
        BudgetPackage(
          name: "Kuota Hemat 50000",
          validity: "30 Days",
          benefit: "16 GB",
          price: 50000,
          provider: "Halo Basic",
        ),
      ];

      emit(BudgetPackageLoaded(dummy));
    });
  }
}
