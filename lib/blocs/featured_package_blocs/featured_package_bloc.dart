import 'package:flutter_bloc/flutter_bloc.dart';
import 'featured_package_event.dart';
import 'featured_package_state.dart';
import '../../models/featured_package.dart';

class FeaturedPackageBloc extends Bloc<FeaturedPackageEvent, FeaturedPackageState> {
  FeaturedPackageBloc() : super(FeaturedPackageInitial()) {
    on<LoadFeaturedPackages>((event, emit) {
      final dummyPackages = [
        FeaturedPackage(name: 'Recommended Package'),
        FeaturedPackage(name: 'Ekstra Kuota'),
        FeaturedPackage(name: 'Youtube Premium'),
        FeaturedPackage(name: 'Internet RoaMAX'),
        FeaturedPackage(name: 'Internet RoaMAX Singapore'),
        FeaturedPackage(name: 'Internet RoaMAX Asia Australia'),
        FeaturedPackage(name: 'Internet RoaMAX Arab Saudi'),
        FeaturedPackage(name: 'GIGAMAX'),
      ];
      emit(FeaturedPackageLoaded(dummyPackages));
    });
  }
}
