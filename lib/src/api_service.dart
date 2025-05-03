class ApiService {
  static const String serverUrl = String.fromEnvironment('SERVER_URL');

  static const String upload = "$serverUrl/api/upload";
  static const String ask = "$serverUrl/api/ask";
}
