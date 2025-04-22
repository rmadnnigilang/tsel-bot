import 'package:flutter_bloc/flutter_bloc.dart';
import 'voucher_event.dart';
import 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  VoucherBloc() : super(VoucherState()) {
    on<SwitchVoucherTab>((event, emit) {
      emit(state.copyWith(selectedTab: event.tabIndex));
    });
  }
}
