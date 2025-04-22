abstract class VoucherEvent {}

class SwitchVoucherTab extends VoucherEvent {
  final int tabIndex;
  SwitchVoucherTab(this.tabIndex);
}
