import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Supabase Configuration (loaded from .env)
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Deep Link Configuration
  static const String appScheme = 'loginpro';

  // Vercel URLs (loaded from .env)
  static String get vercelBaseUrl => dotenv.env['VERCEL_BASE_URL'] ?? '';
  static const String emailVerificationPath = '/verify-email';
  static const String resetPasswordPath = '/reset-password';

  // Error Messages
  static const String networkError = 'Sin conexión a internet';
  static const String serverError = 'Error del servidor';
  static const String authError = 'Error de autenticación';
  static const String unknownError = 'Error desconocido';
}
