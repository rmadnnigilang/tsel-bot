import 'package:flutter_bloc/flutter_bloc.dart';
import 'menu_event.dart';
import 'menu_state.dart';
import '../../repositories/menu_repository.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc(this.menuRepository) : super(MenuInitial()) {
    on<LoadMenu>((event, emit) {
      final items = menuRepository.getMenuItems();
      emit(MenuLoaded(items));
    });
  }
}
