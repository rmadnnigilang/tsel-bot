import '../../models/featured_package.dart';

abstract class FeaturedPackageState {}

class FeaturedPackageInitial extends FeaturedPackageState {}

class FeaturedPackageLoaded extends FeaturedPackageState {
  final List<FeaturedPackage> packages;

  FeaturedPackageLoaded(this.packages);
}
