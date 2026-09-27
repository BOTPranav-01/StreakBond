/// In-memory store for recent verification codes in development and hackathon demo mode.
/// Allows judges and testers to sign in without an external SMTP service.
class VerificationCodeStore {
  static final Map<String, String> _codes = {};

  /// Stores a verification code for the given email.
  static void setCode(String email, String code) {
    _codes[email.trim().toLowerCase()] = code;
  }

  /// Retrieves the latest verification code for the given email.
  static String? getCode(String email) {
    return _codes[email.trim().toLowerCase()];
  }
}
