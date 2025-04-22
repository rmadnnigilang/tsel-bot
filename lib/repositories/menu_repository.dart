import '../models/menu_item.dart';

class MenuRepository {
  List<MenuItem> getMenuItems() {
    return [
      MenuItem(title: 'Buy Featured Package', category: 'Package & Credit'),
      MenuItem(title: 'Buy Budget Package', category: 'Package & Credit'),
      MenuItem(title: 'Voucher Internet', category: 'Package & Credit'),
      MenuItem(title: 'IndiHome Registration', category: 'IndiHome'),
      MenuItem(title: 'Track IndiHome Order', category: 'IndiHome'),
      MenuItem(title: 'Buy Orbit Modem', category: 'Other'),
      MenuItem(title: 'Bot', category: 'Other'),
    ];
  }
}
