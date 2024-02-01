
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class IssueDataRepo {
  static Future fetchIssueData(String url) async {
    String apiKey = dotenv.env['API_KEY'] ?? 'default_value';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
    );
    return response;
  }
}
