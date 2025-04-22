import '../../models/menu_item.dart';

abstract class MenuState {}

class MenuInitial extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuItem> items;

  MenuLoaded(this.items);
}
