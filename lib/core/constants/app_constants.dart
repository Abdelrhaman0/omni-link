/// App-wide configuration constants
class AppConstants {
  AppConstants._();

  // ─── API ───────────────────────────────────────────────────────────────────
  static const String baseUrl = 'https://api.omni-link.com/v1';
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ─── Pagination ────────────────────────────────────────────────────────────
  static const int pageSize = 20;

  // ─── Cache ─────────────────────────────────────────────────────────────────
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';
  static const String cartKey = 'cart_items';
}
