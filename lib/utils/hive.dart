import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:lextorah_chat_bot/hive/uploaded_file_hive_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart'; // Required for Fluttertoast on some platforms

Future<void> initHive() async {
  try {
    // Initialize Hive (uses IndexedDB on Web, local storage on Mobile)
    await Hive.initFlutter();

    // Register adapters if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UploadedFileHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UploadStatusAdapter());
    }

    // Open your Hive box
    await Hive.openBox<UploadedFileHiveModel>('uploaded');
  } catch (e) {
    Fluttertoast.showToast(
      msg: "Hive init error: $e",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    rethrow; // Optional: rethrow if you want to fail fast or log elsewhere
  }
}
