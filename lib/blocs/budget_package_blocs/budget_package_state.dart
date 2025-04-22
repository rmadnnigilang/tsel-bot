import '../../models/budget_package.dart';

abstract class BudgetPackageState {}

class BudgetPackageLoading extends BudgetPackageState {}

class BudgetPackageLoaded extends BudgetPackageState {
  final List<BudgetPackage> packages;

  BudgetPackageLoaded(this.packages);
}
