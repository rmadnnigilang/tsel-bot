import '../../models/internet_package.dart';

abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageLoaded extends PackageState {
  final List<InternetPackage> packages;
  final int currentPage;
  final int totalPages;

  PackageLoaded({
    required this.packages,
    required this.currentPage,
    required this.totalPages,
  });
}

class PackageBuying extends PackageState {}

class PackageBought extends PackageState {
  final String message;
  PackageBought(this.message);
}

class PackageError extends PackageState {
  final String error;
  PackageError(this.error);
}
