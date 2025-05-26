class AppUrls {
  static const String APP_NAME = 'Speech To Text';
  static const double APP_VERSION = 1.0;
  static const String BASE_URL = "http://3.111.84.122"; //
  static const String login = "/api/v1/user/users_login/";
  static const String signUp = "/api/v1/auth/register-email";
  static const String otpVerify = "/api/v1/user/otp_verify/";
  static const String forgetPassword = "/api/v1/user/send_otp/";
  static const String otpVerifyForgot = "/api/v1/auth/verify-otp";
  static const String changePassword = "/api/v1/auth/update-password";
  static const String chat = "/api/v1/auth/email-login";
  static const String resendOtp = "/api/v1/auth/resend-otp";
  static const String get_all_dictation =
      "/api/v1/dictation/get_all_dictation/";
  static const String get_all_folders = "/api/v1/dictation/get_folder/";
  static const String create_dic = "/api/v1/dictation/create_dictation/";
  static const String create_folder = "/api/v1/dictation/create_folders/";
  static const String deleteDic = "/api/v1/dictation/delete_all_dictation/";
  static const String setting =
      "/api/v1/settings/get_setting_all/?page=1&size=50";
       static const String updatesetting =
      "/api/v1/settings/create_settings/";
       static const String getUser ="/api/v1/user/get_user/";
       static const String local_to_server = "/api/v1/dictation/re_upload/";
       //local_to_server
     
}
