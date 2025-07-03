import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // This will be auto-generated

Future<void> initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
