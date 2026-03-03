class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://10.10.7.33:5002/api/v1';

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh-token';

  // Registration & Verification
  static const String signup = '/user';
  static const String resendVerifyEmail = '/auth/resend-verify-email';
  static const String verifyEmail = '/auth/verify-email';

  // Password Management
  static const String forgotPassword = '/auth/forget-password';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';

  // User Endpoints
  //static const String profile = '/user/profile';
  static const String userProfile = '/user/profile';
  // Marketplace Endpoints
  static const String items = '/items';

  // Create JobEndpoint
  static const String createJob = '/jobs';
  static const String myJobs = '/jobs/my-jobs';

  static const String getAllJobOffers = '/jobs';
  static const String applytoJob = '/jobs/{jobId}/apply';
  static const String myRides = '/jobs/my-rides';
}