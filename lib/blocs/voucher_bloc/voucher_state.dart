class VoucherState {
  final int selectedTab;

  VoucherState({this.selectedTab = 0});

  VoucherState copyWith({int? selectedTab}) {
    return VoucherState(
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
