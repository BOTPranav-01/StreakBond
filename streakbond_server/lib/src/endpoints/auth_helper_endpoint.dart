import 'package:serverpod/serverpod.dart';
import '../business/verification_code_store.dart';

/// Public helper endpoint for authentication during hackathon evaluation.
/// Enables seamless testing of the sign-up flow without third-party SMTP services.
class AuthHelperEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;

  /// Retrieves the latest verification code generated for an email.
  Future<String?> getLatestVerificationCode(
    Session session,
    String email,
  ) async {
    final code = VerificationCodeStore.getCode(email);
    session.log(
      'Fetched verification code for $email: ${code != null ? "[FOUND]" : "[NOT FOUND]"}',
      level: LogLevel.info,
    );
    return code;
  }
}
