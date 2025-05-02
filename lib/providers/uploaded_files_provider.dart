import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lextorah_chat_bot/hive/uploaded_file_hive_model.dart';

// This will hold a list of UploadedFileHiveModel objects
final uploadedFilesProvider =
    StateNotifierProvider<UploadedFilesNotifier, List<UploadedFileHiveModel>>((
      ref,
    ) {
      return UploadedFilesNotifier();
    });

class UploadedFilesNotifier extends StateNotifier<List<UploadedFileHiveModel>> {
  UploadedFilesNotifier() : super([]) {
    _loadFilesFromHive();
  }

  // Load files from Hive
  Future<void> _loadFilesFromHive() async {
    final box = await Hive.openBox<UploadedFileHiveModel>('uploaded');
    state = box.values.toList();
  }

  // Add a new file to the list and Hive
  Future<void> addFile(UploadedFileHiveModel file) async {
    final box = await Hive.openBox<UploadedFileHiveModel>('uploaded');
    await box.add(file); // Save to Hive
    state = [...state, file]; // Update the state
  }
}
