import 'package:get/state_manager.dart';

class DashboardController extends GetxController {
  final _selectedIndex = 2.obs;
  get selectedIndex => _selectedIndex.value;

  void changeIndex(int index) {
    _selectedIndex.value = index;
  }
}
