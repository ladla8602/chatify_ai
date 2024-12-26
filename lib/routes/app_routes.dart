import 'package:get/get.dart';

import '../views/auth/forgot_password_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/otp_code_view.dart';
import '../views/auth/set_password_view.dart';
import '../views/auth/signin_view.dart';
import '../views/auth/singup_view.dart';
import '../views/chat/chat_content_view.dart';
import '../views/chat/chat_view.dart';
import '../views/dashboard_view.dart';
import '../views/language/language_view.dart';
import '../views/payment/add_payment_view.dart';
import '../views/payment/payment_methods_view.dart';
import '../views/settings/custom_instruction_view.dart';
import '../views/settings/data_controls_view.dart';
import '../views/settings/setting_view.dart';
import '../views/upgrade/upgrade_view.dart';

class AppRoutes {
  static const login = '/login';
  static const signin = '/signin';
  static const signup = '/signup';
  static const forgotpassword = '/forgotpassword';
  static const setPassword = '/setPassword';
  static const otpaccess = '/otpaccess';
  static const dashboard = '/dashboard';
  static const chatview = '/chatview';
  static const chatContentView = '/chatContentView';
  static const upgrade = '/upgrade';
  static const setting = '/setting';
  static const customInstruction = '/customInstruction';
  static const dataControls = '/dataControls';
  static const paymentMethods = '/paymentMethods';
  static const addPaymentMethods = '/addPaymentMethods';
  static const languaeview = '/languaeview';

  static final pages = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signin, page: () => SigninView()),
    GetPage(name: signup, page: () => SingupView()),
    GetPage(name: otpaccess, page: () => OtpCodeView()),
    GetPage(name: forgotpassword, page: () => ForgotPasswordView()),
    GetPage(name: setPassword, page: () => SetPasswordView()),
    GetPage(name: chatview, page: () => ChatView()),
    GetPage(name: chatContentView, page: () => ChatContentView()),
    GetPage(name: upgrade, page: () => UpgradeView()),
    GetPage(name: setting, page: () => SettingView()),
    GetPage(name: customInstruction, page: () => CustomInstructionView()),
    GetPage(name: dataControls, page: () => DataControlsView()),
    GetPage(name: paymentMethods, page: () => PaymentMethodsView()),
    GetPage(name: addPaymentMethods, page: () => AddPaymentView()),
    GetPage(name: languaeview, page: () => LanguageView()),
    GetPage(name: dashboard, page: () => DashboardView()),
  ];
}
