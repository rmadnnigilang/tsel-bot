abstract class PackageEvent {}

class FetchPackages extends PackageEvent {
  final int page; // Page number to fetch
  final int limit; // Number of items per page

  FetchPackages({this.page = 1, this.limit = 100}); // Default values for page and limit
}

class BuyPackage extends PackageEvent {
  final String packageId;
  final String paymentMethod;

  BuyPackage({required this.packageId, required this.paymentMethod});
}
