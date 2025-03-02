import 'package:faleh_hafez/domain/models/user_reginster_login_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveCredentials(
      String mobileNumber, String password, String userName) async {
    await _storage.write(key: "mobileNumber", value: mobileNumber);
    await _storage.write(key: "password", value: password);
    await _storage.write(key: "userName", value: userName);
  }

  Future<UserRegisterDTO> getCredentials() async {
    String? mobileNumber = await _storage.read(key: "mobileNumber");
    String? password = await _storage.read(key: "password");
    String? userName = await _storage.read(key: "userName");

    return
        // {
        UserRegisterDTO(
      password: password!,
      mobileNumber: mobileNumber!,
      userName: userName!,
    );
    // "mobileNumber": mobileNumber,
    // "password": password,
    // };
  }

  Future<void> deleteCredentials() async {
    await _storage.deleteAll();
  }
}
