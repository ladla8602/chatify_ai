import 'package:chatify_ai/views/history/history_view.dart';
import 'package:get/get.dart';

import '../views/auth/forgot_password_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/otp_code_view.dart';
import '../views/auth/signin_view.dart';
import '../views/auth/singup_view.dart';
import '../views/chat/chat_view.dart';
import '../views/dashboard_view.dart';
import '../views/upgrade/upgrade_view.dart';

class AppRoutes {
  static const login = '/login';
  static const signin = '/signin';
  static const signup = '/signup';
  static const forgotpassword = '/forgotpassword';
  static const otpaccess = '/otpaccess';
  static const dashboard = '/dashboard';
  static const chatview = '/chatview';
  static const upgrade = '/upgrade';
  static const history = '/history';

  static final pages = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signin, page: () => SigninView()),
    GetPage(name: signup, page: () => SingupView()),
    GetPage(name: otpaccess, page: () => OtpCodeView()),
    GetPage(name: forgotpassword, page: () => ForgotPasswordView()),
    GetPage(name: chatview, page: () => ChatView()),
    GetPage(name: upgrade, page: () => UpgradeView()),
    GetPage(name: dashboard, page: () => DashboardView()),
    GetPage(name: history, page: () => History()),
  ];
}
