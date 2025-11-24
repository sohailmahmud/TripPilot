import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logger_util.dart';

/// Secure storage utility for storing sensitive data like tokens, credentials, and keys.
/// Uses platform-specific secure storage (Keychain on iOS, Keystore on Android).
class SecureStorageUtil {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
  );

  /// Save a sensitive key-value pair securely.
  static Future<void> saveSecure(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      AppLogger.debug('Saved secure key: $key');
    } catch (e) {
      AppLogger.error('Failed to save secure key: $key', error: e);
      rethrow;
    }
  }

  /// Retrieve a sensitive value by key.
  static Future<String?> getSecure(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value != null) {
        AppLogger.debug('Retrieved secure key: $key');
      }
      return value;
    } catch (e) {
      AppLogger.error('Failed to retrieve secure key: $key', error: e);
      return null;
    }
  }

  /// Delete a sensitive key-value pair.
  static Future<void> deleteSecure(String key) async {
    try {
      await _storage.delete(key: key);
      AppLogger.debug('Deleted secure key: $key');
    } catch (e) {
      AppLogger.error('Failed to delete secure key: $key', error: e);
      rethrow;
    }
  }

  /// Clear all secure storage.
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
      AppLogger.info('Cleared all secure storage');
    } catch (e) {
      AppLogger.error('Failed to clear secure storage', error: e);
      rethrow;
    }
  }

  /// Check if a key exists in secure storage.
  static Future<bool> hasKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null;
    } catch (e) {
      AppLogger.error('Failed to check key existence: $key', error: e);
      return false;
    }
  }
}

/// Key constants for secure storage
class SecureStorageKeys {
  // Authentication tokens
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  
  // Sensitive credentials
  static const String email = 'user_email';
  static const String password = 'user_password';
  
  // API keys
  static const String apiKey = 'api_key';
  static const String supabaseKey = 'supabase_key';
}
