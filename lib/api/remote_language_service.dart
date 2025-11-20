import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:newflutter/api/app_locale.dart';

class RemoteLanguageService {
  //final TokenService _tokenService = TokenService();

  Future<List<Map<String, dynamic>?>> fetchAllLang() async {
    try {
      final headers = {'Content-Type': 'application/json'};
      final output = await http.get(
        Uri.parse("https://nirob.signalsmind.com/s3/api/admin/languages"),
        headers: headers,
      );
      log(output.toString());
      log("Hello 1");
      final response = json.decode(output.body);
      log("Hello 2");
      log(response.toString());

      if (response['success'] == true && response['data'] != null) {
        return (response['data'] as List)
            .map((e) => e as Map<String, dynamic>?)
            .toList();
      }
    } catch (e) {
      log("Hello 4");
      log('Error fetching Language data: $e');
      return [];
    }
    return [];
  }

  Future<void> addRemoteLangToAppLocale(String langCode, String fileUrl) async {
    try {
      // Fetch the JSON file from the URL
      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        // Decode the JSON into a Map
        final Map<String, dynamic> jsonMap = json.decode(response.body);

        // Add it to AppLocale.map
        AppLocale.map[langCode] = jsonMap;

        log("Language $langCode added successfully!");
      } else {
        log("Failed to fetch language file: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching language file: $e");
    }
  }
}
