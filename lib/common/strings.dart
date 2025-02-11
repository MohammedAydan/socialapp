import 'package:flutter_dotenv/flutter_dotenv.dart';

String SUPABASE_URL = dotenv.env['SUPABASE_URL'] ?? "";
String SUPABASE_KEY = dotenv.env['SUPABASE_KEY'] ?? "";
String ONESIGNAL_KEY = dotenv.env['ONESIGNAL_APP_ID'] ?? "";
