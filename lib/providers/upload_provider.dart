import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:lextorah_chat_bot/admin/components/file_upload_box.dart';
import 'package:lextorah_chat_bot/hive/uploaded_file_hive_model.dart';
import 'package:lextorah_chat_bot/providers/uploaded_files_provider.dart';
import 'package:lextorah_chat_bot/src/api_service.dart'; // Replace with correct path

final uploadControllerProvider =
    StateNotifierProvider<UploadController, AsyncValue<void>>(
      (ref) => UploadController(ref),
    );

class UploadController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  UploadController(this.ref) : super(const AsyncData(null));

  Future<void> uploadFiles() async {
    final pickedFiles = ref.read(pickedFilesProvider);
    if (pickedFiles.isEmpty) return;
    final errors = <String>[];
    for (final file in pickedFiles) {
      state = const AsyncLoading();

      try {
        final uri = Uri.parse(ApiService.upload);
        if (file.bytes == null) throw Exception("File bytes are null");

        final request = http.MultipartRequest('POST', uri)
          ..files.add(
            http.MultipartFile.fromBytes(
              'file',
              file.bytes!,
              filename: file.name,
            ),
          );

        final response = await request.send();
        final success = response.statusCode == 200;

        await ref
            .read(uploadedFilesProvider.notifier)
            .addFile(
              UploadedFileHiveModel(
                name: file.name,
                timestamp: DateTime.now().millisecondsSinceEpoch,
                status: success ? UploadStatus.success : UploadStatus.failed,
              ),
            );

        if (!success) {
          final responseBody = await response.stream.bytesToString();
          try {
            final decoded = jsonDecode(responseBody);
            final detail = decoded['detail'] ?? 'Unknown error';
            errors.add("${file.name}: $detail");
          } catch (_) {
            errors.add("${file.name}: Unexpected error");
          }
        }
      } catch (e) {
        if (e is SocketException) {
          errors.add(
            "${file.name}: Network error. Please check your internet connection.",
          );
        } else if (e is FormatException) {
          errors.add("${file.name}: Invalid file format.");
        } else {
          errors.add("${file.name}: Unexpected error ");
        }
      }
    }

    // Clear after all uploads
    ref.read(pickedFilesProvider.notifier).state = [];
    if (errors.isNotEmpty) {
      state = AsyncError(
        "Some uploads failed, Please attached valid file types:\n${errors.join('\n')}",

        StackTrace.current,
      );
    } else {
      state = const AsyncData(null);
    }
  }

  // Future<void> uploadFile() async {
  //   final pickedFile = ref.read(pickedFileProvider);
  //   if (pickedFile == null) return;

  //   state = const AsyncLoading();

  //   try {
  //     final uri = Uri.parse(ApiService.upload); // Replace this
  //     final fileBytes = pickedFile.bytes;
  //     final fileName = pickedFile.name;

  //     if (fileBytes == null) {
  //       throw Exception("File bytes are null");
  //     }

  //     final request = http.MultipartRequest('POST', uri)
  //       ..files.add(
  //         http.MultipartFile.fromBytes('file', fileBytes, filename: fileName),
  //       );

  //     final response = await request.send();

  //     final success = response.statusCode == 200;

  //     // Save status to Hive
  //     await ref
  //         .read(uploadedFilesProvider.notifier)
  //         .addFile(
  //           UploadedFileHiveModel(
  //             name: fileName,
  //             timestamp: DateTime.now().millisecondsSinceEpoch,
  //             status: success ? UploadStatus.success : UploadStatus.failed,
  //           ),
  //         );

  //     if (success) {
  //       ref.read(pickedFileProvider.notifier).state = null;
  //     }

  //     if (!success) {
  //       print(response);
  //       throw Exception("Upload failed with status ${response.statusCode}");
  //     }

  //     state = const AsyncData(null);
  //   } catch (e, st) {
  //     state = AsyncError(e, st);
  //   }
  // }
}
