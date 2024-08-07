import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class Globals {
  static String appVersion = (dotenv.env['APP_VERSION'] ?? '0.0.1');
  static DateFormat dfYYMM = DateFormat('yy/MM');
  static DateFormat dfMon = DateFormat('MMM');
  static DateFormat dfYY = DateFormat('yy');
  static DateFormat dfyyyyMMdd = DateFormat('yyyy-MM-dd');

  // URL portion for the NetUtils
  static String apiURL = (dotenv.env['API_URL'] ?? 'http://192.168.1.176:1337');
  static int apiTimeOut = 30;

  static String apiPinVerify = '$apiURL/api/plan/pin/verify';
}