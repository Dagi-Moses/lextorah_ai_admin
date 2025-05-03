class ApiService {
  static const String serverUrl = String.fromEnvironment(
    'SERVER_URL',
    defaultValue: "https://ai1-zjt4.onrender.com",
  );

  static const String upload = "$serverUrl/api/upload";
  static const String ask = "$serverUrl/api/ask";
}
