import 'package:get/get.dart';

import '../views/auth/forgot_password_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/otp_code_view.dart';
import '../views/auth/signin_view.dart';
import '../views/auth/singup_view.dart';
import '../views/chat/chat_view.dart';
import '../views/dashboard_view.dart';

class AppRoutes {
  static const login = '/login';
  static const signin = '/signin';
  static const signup = '/signup';
  static const forgotpassword = '/forgotpassword';
  static const otpaccess = '/otpaccess';
  static const dashboard = '/dashboard';
  static const chatview = '/chatview';

  static final pages = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signin, page: () => SigninView()),
    GetPage(name: signup, page: () => SingupView()),
    GetPage(name: otpaccess, page: () => OtpCodeView()),
    GetPage(name: forgotpassword, page: () => ForgotPasswordView()),
    GetPage(name: chatview, page: () => ChatView()),
    GetPage(name: dashboard, page: () => DashboardView()),
  ];
}
