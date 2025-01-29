import 'package:chatify_ai/about_chatify/about_chatify_screen.dart';
import 'package:chatify_ai/bindings/dashboard_bindings.dart.dart';
import 'package:chatify_ai/controllers/chatbot_controller.dart';
import 'package:chatify_ai/views/help_center/help_center_view.dart';
import 'package:chatify_ai/views/history/history_view.dart';
import 'package:chatify_ai/views/linked_account/linked_accounts.dart';
import 'package:chatify_ai/views/payment/review_summary.dart';
import 'package:chatify_ai/views/payment/select_payment_method.dart';
import 'package:chatify_ai/views/payment/successfully_screen.dart';
import 'package:chatify_ai/views/personal_info/persnol_info.dart';
import 'package:chatify_ai/views/security/security_view.dart';
import 'package:get/get.dart';
import '../views/audio/audio_view.dart';
import '../views/auth/forgot_password/create_new_password_view.dart';
import '../views/auth/forgot_password/forgot_password_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/forgot_password/otp_code_view.dart';
import '../views/auth/set_password_view.dart';
import '../views/auth/signin_view.dart';
import '../views/auth/singup_view.dart';
import '../views/chat/chat_content_view.dart';
import '../views/chat/chat_view.dart';
import '../views/dashboard_view.dart';
import '../views/image/image_generate_view.dart';
import '../views/language/language_view.dart';
import '../views/payment/add_payment_view.dart';
import '../views/payment/payment_methods_view.dart';
import '../views/settings/custom_instruction_view.dart';
import '../views/settings/data_controls_view.dart';
import '../views/settings/setting_view.dart';
import '../views/upgrade/upgrade_view.dart';
import '../widgets/common_page.dart';

class AppRoutes {
  static const login = '/login';
  static const signin = '/signin';
  static const signup = '/signup';
  static const forgotpassword = '/forgotpassword';
  static const createNewPassword = '/createNewPassword';
  static const setPassword = '/setPassword';
  static const otpaccess = '/otpaccess';
  static const dashboard = '/dashboard';
  static const chatview = '/chatview';
  static const chatContentView = '/chatContentView';
  static const upgrade = '/upgrade';
  static const setting = '/setting';
  static const history = '/history';
  static const customInstruction = '/customInstruction';
  static const dataControls = '/dataControls';
  static const paymentMethods = '/paymentMethods';
  static const addPaymentMethods = '/addPaymentMethods';
  static const linkedAccount = '/linkedAccount';
  static const personalInfo = '/personalInfo';
  static const security = '/scurity';

  static const languaeview = '/languaeview';

  static const imageView = '/imageView';
  static const audioView = '/audioView';
  static const commonpageView = '/commonpageView';
  static const helpCenterView = '/helpCenterView';
  static const termsOfUse = '/termsOfUse';
  static const privacyPolicy = '/privacyPolicy';
  static const aboutChatify = '/aboutChatify';
  static const paymentMethodsSelect = '/paymentMethodsSelect';
  static const reviewSummary = '/reviewSummary';
  static const successfullyScreen = '/successfullyScreen';

  static final pages = [
    GetPage(name: login, page: () => LoginView()),
    GetPage(name: signin, page: () => SigninView()),
    GetPage(name: signup, page: () => SingupView()),
    GetPage(name: otpaccess, page: () => OtpCodeView()),
    GetPage(name: forgotpassword, page: () => ForgotPasswordView()),
    GetPage(name: createNewPassword, page: () => CreateNewPasswordView()),
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
    GetPage(
        name: dashboard,
        page: () => DashboardView(),
        binding: DashboardBindings()),
    GetPage(name: history, page: () => HistoryView()),
    GetPage(name: linkedAccount, page: () => Linked_Account()),
    GetPage(name: personalInfo, page: () => PersonalInfo()),
    GetPage(name: security, page: () => SecurityView()),
    GetPage(name: imageView, page: () => ImageGenerateView()),
    GetPage(name: audioView, page: () => AudioGenerateView()),
    GetPage(name: commonpageView, page: () => CommonPageView()),
    GetPage(name: helpCenterView, page: () => HelpCenterView()),
    GetPage(name: aboutChatify, page: () => AboutChatifyScreen()),
    GetPage(name: paymentMethodsSelect, page: () => SelectPaymentMethod()),
    GetPage(name: reviewSummary, page: () => ReviewSummary()),
    GetPage(name: successfullyScreen, page: () => SuccessfullyScreen()),
  ];
}
