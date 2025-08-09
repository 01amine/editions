import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String baseUrl = dotenv.env['BASE_URL'] ??
      'http://192.168.100.5:8000';
}
