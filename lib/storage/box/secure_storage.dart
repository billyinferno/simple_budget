import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureBox {
  static const _storage = FlutterSecureStorage();

  static Future<String> get({required String key}) async {
    // get the data from the secure storage
    String? value = await _storage.read(key: key);

    // check whether this is null value, if so make it to empty string
    value = (value ?? '');

    // return the value
    return value;
  }

  static Future<void> put({required String key, required String value}) async {
    await _storage.write(key: key, value: value);
  }

  static Future<void> delete({required String key}) async {
    await _storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  static Future<Map<String, String>> readAll() async {
    final Map<String, String> value = await _storage.readAll();
    return value;
  }
}