abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, dynamic> profile;
  final List<dynamic> purchaseHistory;
  final List<dynamic> recommendations;

  ProfileLoaded({
    required this.profile,
    required this.purchaseHistory,
    required this.recommendations,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}
