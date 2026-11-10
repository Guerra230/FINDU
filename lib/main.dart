import 'package:flutter/material.dart';

import 'package:findu/app.dart';
import 'package:findu/core/supabase/supabase_setup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!SupabaseSetup.isConfigured) {
    runApp(const MissingConfigApp());
    return;
  }
  await SupabaseSetup.init();
  runApp(const FinduApp());
}
