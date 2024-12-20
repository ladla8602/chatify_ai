import 'package:get/get.dart';

import '../views/auth/login_view.dart';
import '../views/dashboard_view.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';

  static final pages = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: dashboard, page: () => DashboardView()),
  ];
}
