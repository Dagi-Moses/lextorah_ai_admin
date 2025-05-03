import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lextorah_chat_bot/admin/components/file_upload_box.dart';

import 'package:lextorah_chat_bot/admin/components/uploaded_files_table.dart';
import 'package:lextorah_chat_bot/providers/upload_provider.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Welcome, Admin!',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(),
                      // ElevatedButton(
                      //   onPressed: () {},
                      //   child: const Text('Logout'),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FileUploadBox(),
                  const SizedBox(height: 24),
                  //  _buildUploadedFilesTable(context),
                  UploadedFilesTable(),
                  const SizedBox(height: 24),

                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: theme.colorScheme.primary,
                  //   ),
                  //   onPressed: () {},
                  //   child: Text(
                  //     'Train model',
                  //     style: TextStyle(
                  //       overflow: TextOverflow.ellipsis,
                  //       color: theme.colorScheme.onPrimary,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,

            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Consumer(
                builder: (context, ref, _) {
                  final uploadState = ref.watch(uploadControllerProvider);

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (uploadState is AsyncError)
                        Text(
                          textAlign: TextAlign.center,
                          '${uploadState.error}',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                        ),
                        onPressed:
                            uploadState is AsyncLoading
                                ? null
                                : () {
                                  ref
                                      .read(uploadControllerProvider.notifier)
                                      .uploadFiles();
                                },
                        child:
                            uploadState is AsyncLoading
                                ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: const CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  'Train model',
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
