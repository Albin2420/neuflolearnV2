import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';

import 'package:neuflo_learn/src/app.dart';
import 'package:neuflo_learn/src/data/models/chapter.dart';
import 'package:neuflo_learn/src/data/models/course.dart';
import 'package:neuflo_learn/src/data/services/firebase/notification_services.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // options: DefaultFirebaseOptions.currentPlatform
  await preRequisites();
  await NotificationServices.instance.initialize();

  runApp(const NeufloLearn());
}

Future preRequisites() async {
  await dotenv.load(fileName: ".env");
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init('${directory.path}/neuflodb');

  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(ChapterAdapter());
}
