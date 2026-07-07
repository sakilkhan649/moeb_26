import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:moeb_26/core/widgets/screens/no_internet_screen.dart';
import 'package:moeb_26/modules/auth/Term_and_policy/bindings/term_and_policy_binding.dart';
import 'package:moeb_26/modules/auth/Term_and_policy/views/privacy_policy_signup_view.dart';
import 'package:moeb_26/modules/auth/Term_and_policy/views/term_policy_view.dart';
import 'package:moeb_26/modules/auth/authentication/bindings/auth_binding.dart';
import 'package:moeb_26/modules/auth/vehicle/views/add_new_vehicle_view.dart';
import 'package:moeb_26/modules/bottom_nab_bar/bindings/bottom_nabbar_binding.dart';
import 'package:moeb_26/modules/chat/bindings/chat_bindings.dart';
import 'package:moeb_26/modules/chat_community/bindings/chat_community_detail_binding.dart';
import 'package:moeb_26/modules/chat_detail/bindings/chat_detail_binding.dart';
import 'package:moeb_26/modules/auth/profile/bindings/profile_binding.dart';
import 'package:moeb_26/modules/job_edit/bindings/job_edit_binding.dart';
import 'package:moeb_26/modules/my_jobs/bindings/my_jobs_binding.dart';
import 'package:moeb_26/modules/my_items/bindings/my_items_binding.dart';
import 'package:moeb_26/modules/ride_completed/bindings/ride_completed_binding.dart';
import 'package:moeb_26/modules/ride_details/bindings/ride_details_binding.dart';
import 'package:moeb_26/modules/service_Area/views/Service_Area_view.dart';
import 'package:moeb_26/modules/service_area/bindings/service_area_binding.dart';
import 'package:moeb_26/modules/auth/authentication/views/all_vehicle_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/application_not_Approved_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/application_submited_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/account_succes_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/change_password_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/create_account_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/documents_upload_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/otp_verifications_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/personal_document_view.dart';
import 'package:moeb_26/modules/auth/profile/views/profile_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/reset_password_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/reset_password_three_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/success_reset_password_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/signin_view.dart';
import 'package:moeb_26/modules/auth/splash/binding/splash_binding.dart';
import 'package:moeb_26/modules/auth/splash/views/splash_view.dart';
import 'package:moeb_26/modules/auth/vehicle/views/vehicle_Information_view.dart';
import 'package:moeb_26/modules/auth/authentication/views/auth_selection_view.dart';
import 'package:moeb_26/modules/bottom_nab_bar/views/bottom_nabbar_view.dart';
import 'package:moeb_26/modules/chat_detail/views/chat_detail_view.dart';
import 'package:moeb_26/modules/chat/views/chat_view.dart';
import 'package:moeb_26/modules/chat_community/views/chat_community_detail_view.dart';
import 'package:moeb_26/modules/chat_support_detail/views/chat_support_detail_view.dart';
import 'package:moeb_26/modules/jobs_approve/views/job_approve_view.dart';
import 'package:moeb_26/modules/job_edit/views/job_edit_view.dart';
import 'package:moeb_26/modules/ratings_feedback/views/ratings_feedback_view.dart';
import 'package:moeb_26/modules/ride_progress_way_location/views/ride_progress_way_location_view.dart';
import 'package:moeb_26/modules/my_jobs/views/my_jobs_view.dart';
import 'package:moeb_26/modules/request_submitted/views/request_submitted_view.dart';
import 'package:moeb_26/modules/my_items/views/my_Items_view.dart';
import 'package:moeb_26/modules/request_under_review/views/request_under_review_view.dart';
import 'package:moeb_26/modules/ride_completed/views/ride_completed_view.dart';
import 'package:moeb_26/modules/ride_details/views/ride_details_view.dart';
import 'package:moeb_26/modules/deals/views/deals_view.dart';
import 'package:moeb_26/modules/deals/bindings/deals_binding.dart';
import 'package:moeb_26/modules/invoice/bindings/invoice_binding.dart';
import 'package:moeb_26/modules/invoice/views/create_invoice_view.dart';
import 'package:moeb_26/modules/invoice/views/invoice_history_view.dart';
import 'package:moeb_26/modules/preferred_drivers/bindings/preferred_drivers_binding.dart';
import 'package:moeb_26/modules/preferred_drivers/views/preferred_drivers_view.dart';
import 'package:moeb_26/modules/preferred_drivers/views/preferred_driver_profile_view.dart';

class Routes {
  static const String splashView = "/SplashView";
  static const String authSelectionView = "/AuthSelectionView";
  static const String signinView = "/SignInView";
  static const String createaccountview = "/Createaccountview";
  static const String resetPasswordView = "/ResetPasswordView";
  //static const String resetpasswordtwo = "/Resetpasswordtwo";
  static const String resetpasswordthreeView = "/ResetpasswordthreeView";
  static const String successResetPasswordView = "/SuccessResetPasswordView";
  static const String vehicleinformationView = "/Vehicleinformation";
  static const String documentsuploadView = "/DocumentsuploadView";
  static const String termPolicyView = "/TermPolicyView";
  static const String applicationSubmitedView = "/ApplicationSubmitedView";
  static const String applicationNotApprovedView =
      "/ApplicationNotApprovedView";
  static const String bottomNabbarView = "/BottomNabbarView";
  static const String myJobsView = "/MyJobsView";
  static const String jobEditView = "/JobEditView";
  static const String accountSuccessView = "/AccountSuccessView";
  static const String requestSubmittedView = "/RequestSubmittedView";
  static const String requestUnderReviewView = "/RequestUnderReviewView";
  static const String chatView = "/ChatView";
  static const String chatDetailView = "/ChatDetailView";
  static const String chatCommunityDetailView = "/ChatCommunityDetailView";
  static const String rideDetailsView = "/RideDetailsView";
  static const String rideCompletedView = "/RideCompletedView";
  static const String jobApproveView = "/JobApproveView";
  static const String rideProgressWay = "/RideProgressWay";
  static const String rideProgressWayLocationView =
      "/RideProgressWayLocationView";
  static const String rideProgressBoard = "/RideProgressBoard";
  static const String rideCompleteJob = "/RideCompleteJob";
  static const String profileView = "/ProfileView";
  static const String ratingsFeedbackView = "/RatingsFeedbackView";
  static const String serviceAreaView = "/ServiceAreaView";
  static const String noInternetScreen = "/NoInternetScreen";
  static const String otpVerificationView = "/OtpVerificationView";
  static const String forgetotpVerificationView = "/ForgetotpVerificationView";
  static const String changePasswordView = "/ChangePasswordView";
  static const String myItemsView = "/MyItemsView";
  static const String chatSupportDetailView = "/ChatSupportDetailView";
  static const String privacyPolicySignUpView = "/PrivacyPolicySignUpView";
  static const String allVehicleView = "/AllVehicleView";
  static const String addNewVehicleView = "/AddNewVehicleView";
  static const String personalDocumentView = "/PersonalDocumentView";
  static const String dealsView = "/DealsView";
  static const String createInvoiceView = "/CreateInvoiceView";
  static const String invoiceHistoryView = "/InvoiceHistoryView";
  static const String preferredDriversView = "/PreferredDriversView";
  static const String preferredDriverProfileView = "/PreferredDriverProfileView";

  static List<GetPage> routes = [
    GetPage(
      name: splashView,
      page: () => SplashView(),
      transition: Transition.noTransition,
      binding: SplashBinding(),
    ),
    GetPage(
      name: privacyPolicySignUpView,
      page: () => PrivacyPolicySignUpView(),
      transition: Transition.noTransition,
      binding: TermPolicyBinding(),
    ),
    GetPage(
      name: authSelectionView,
      page: () => AuthSelectionView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: signinView,
      page: () => SignInView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: createaccountview,
      page: () => CreateAccountView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: resetPasswordView,
      page: () => ResetPasswordView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: resetpasswordthreeView,
      page: () => ResetPasswordThreeView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: successResetPasswordView,
      page: () => SuccessResetPasswordView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: vehicleinformationView,
      page: () => VehicleInformationView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: documentsuploadView,
      page: () => DocumentsuploadView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: termPolicyView,
      page: () => TermPolicyView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: applicationSubmitedView,
      page: () => ApplicationSubmitedView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: applicationNotApprovedView,
      page: () => ApplicationNotApprovedView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: bottomNabbarView,
      page: () => BottomNabbarView(),
      transition: Transition.noTransition,
      binding: BottomNabbarBinding(),
    ),
    GetPage(
      name: myJobsView,
      page: () => MyJobsView(),
      transition: Transition.noTransition,
      binding: MyJobsBinding(),
    ),
    GetPage(
      name: jobEditView,
      page: () => JobEditView(),
      transition: Transition.noTransition,
      binding: JobEditBinding(),
    ),
    GetPage(
      name: accountSuccessView,
      page: () => AccountSuccessView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: requestSubmittedView,
      page: () => RequestSubmittedView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: requestUnderReviewView,
      page: () => RequestUnderReviewView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: chatView,
      page: () => ChatView(),
      transition: Transition.noTransition,
      binding: ChatBinding(),
    ),
    GetPage(
      name: chatDetailView,
      page: () => ChatDetailView(),
      transition: Transition.noTransition,
      binding: ChatDetailBinding(),
    ),
    GetPage(
      name: chatCommunityDetailView,
      page: () => ChatCommunityDetailView(),
      transition: Transition.noTransition,
      binding: ChatCommunityDetailBinding(),
    ),
    GetPage(
      name: rideDetailsView,
      page: () => RideDetailsView(),
      transition: Transition.noTransition,
      binding: RideDetailsBinding(),
    ),
    GetPage(
      name: rideCompletedView,
      page: () => RideCompletedView(),
      transition: Transition.noTransition,
      binding: RideCompletedBinding(),
    ),
    GetPage(
      name: jobApproveView,
      page: () => JobApproveView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: rideProgressWayLocationView,
      page: () => RideProgressWayLocationView(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: profileView,
      page: () => ProfileView(),
      transition: Transition.noTransition,
      binding: ProfileBinding(),
    ),
    GetPage(
      name: ratingsFeedbackView,
      page: () => RatingsFeedbackView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: serviceAreaView,
      page: () => ServiceAreaView(),
      transition: Transition.noTransition,
      binding: ServiceAreaBinding(),
    ),
    GetPage(
      name: noInternetScreen,
      page: () => NoInternetScreen(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: otpVerificationView,
      page: () => OtpVerificationView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: forgetotpVerificationView,
      page: () => OtpVerificationView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: changePasswordView,
      page: () => ChangePasswordView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: myItemsView,
      page: () => MyItemsView(),
      transition: Transition.noTransition,
      binding: MyItemsBinding(),
    ),

    GetPage(
      name: chatSupportDetailView,
      page: () => SupportChatDetailView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: allVehicleView,
      page: () => AllVehicleView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: addNewVehicleView,
      page: () => AddNewVehicleView(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: personalDocumentView,
      page: () => PersonalDocumentView(),
      transition: Transition.noTransition,
      binding: AuthBinding(),
    ),
    GetPage(
      name: dealsView,
      page: () => DealsView(),
      transition: Transition.noTransition,
      binding: DealsBinding(),
    ),
    GetPage(
      name: createInvoiceView,
      page: () => const CreateInvoiceView(),
      transition: Transition.noTransition,
      binding: InvoiceBinding(),
    ),
    GetPage(
      name: invoiceHistoryView,
      page: () => const InvoiceHistoryView(),
      transition: Transition.noTransition,
      binding: InvoiceBinding(),
    ),
    GetPage(
      name: preferredDriversView,
      page: () => const PreferredDriversView(),
      transition: Transition.noTransition,
      binding: PreferredDriversBinding(),
    ),
    GetPage(
      name: preferredDriverProfileView,
      page: () => const PreferredDriverProfileView(),
      transition: Transition.noTransition,
      binding: PreferredDriversBinding(),
    ),
  ];
}
