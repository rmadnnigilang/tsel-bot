abstract class ProfileEvent {}

class FetchProfileData extends ProfileEvent {
  final String token;

  FetchProfileData(this.token);
}
