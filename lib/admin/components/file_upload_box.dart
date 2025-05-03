import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dropzoneControllerProvider = StateProvider<DropzoneViewController?>(
  (ref) => null,
);
final pickedFilesProvider = StateProvider<List<PlatformFile>>((ref) => []);

class FileUploadBox extends ConsumerWidget {
  const FileUploadBox({super.key});

  Future<void> _pickFile(WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null && result.files.isNotEmpty) {
        ref.read(pickedFilesProvider.notifier).state = result.files;
      }
    } catch (e) {
      print("File pick error: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pickedFiles = ref.watch(pickedFilesProvider);

    return Stack(
      children: [
        // Ensure DropzoneView has a defined size
        Positioned.fill(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
              minWidth: 300,
              maxHeight: 300,
              minHeight: 300,
            ),
            child: DropzoneView(
              operation: DragOperation.copy,
              onCreated:
                  (ctrl) =>
                      ref.read(dropzoneControllerProvider.notifier).state =
                          ctrl,
              onDropFiles: (evList) async {
                try {
                  final ctrl = ref.read(dropzoneControllerProvider);
                  if (ctrl == null) return;

                  final files = <PlatformFile>[];
                  if (evList != null) {
                    for (final ev in evList) {
                      final name = await ctrl.getFilename(ev);
                      final bytes = await ctrl.getFileData(ev);

                      files.add(
                        PlatformFile(
                          name: name,
                          size: bytes.length,
                          bytes: bytes,
                        ),
                      );
                    }
                  }

                  ref.read(pickedFilesProvider.notifier).state = files;
                } catch (e) {
                  print("error dropping fies: " + e.toString());
                }
              },
            ),
          ),
        ),
        // This part is your file display and upload UI
        Center(
          child: InkWell(
            onTap: () {
              _pickFile(ref);
            },
            borderRadius: BorderRadius.circular(12),

            child: DottedBorder(
              color: theme.colorScheme.outline,
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [8, 4],
              strokeWidth: 1.5,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 600,
                  minWidth: 300,
                  maxHeight: 300,
                  minHeight: 300,
                ),
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.folder_open,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    if (pickedFiles.isEmpty)
                      Text(
                        textAlign: TextAlign.center,
                        'Drag and drop files here \n or click to browse',
                        style: theme.textTheme.bodyLarge,
                      )
                    else
                      Container(
                        constraints: const BoxConstraints(maxHeight: 170),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pickedFiles.length,
                          itemBuilder: (context, index) {
                            final file = pickedFiles[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    file.name,
                                    style: theme.textTheme.titleMedium,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(file.size / 1024).toStringAsFixed(2)} KB',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    // Column(
                    //   children: [
                    //     Text(
                    //       pickedFile.name,
                    //       style: theme.textTheme.titleMedium,
                    //       overflow: TextOverflow.ellipsis,
                    //     ),
                    //     const SizedBox(height: 8),
                    //     Text(
                    //       '${(pickedFile.size / 1024).toStringAsFixed(2)} KB',
                    //       style: theme.textTheme.bodyMedium,
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// final pickedFileProvider = StateProvider<PlatformFile?>((ref) => null);

// class FileUploadBox extends ConsumerWidget {
//   const FileUploadBox({super.key});

//   Future<void> _pickFile(WidgetRef ref) async {
//     try {
//       final result = await FilePicker.platform.pickFiles();
//       if (result != null && result.files.isNotEmpty) {
//         ref.read(pickedFileProvider.notifier).state = result.files.first;
//       }
//     } catch (e) {
//       print("error picking document " + e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final theme = Theme.of(context);
//     final pickedFile = ref.watch(pickedFileProvider);

//     return InkWell(
//       onTap: () {
//         _pickFile(ref);
//       },
//       borderRadius: BorderRadius.circular(12),
//       child: DottedBorder(
//         color: theme.colorScheme.outline,
//         borderType: BorderType.RRect,
//         radius: const Radius.circular(12),
//         dashPattern: const [8, 4],
//         strokeWidth: 1.5,
//         child: Container(
//           constraints: const BoxConstraints(
//             maxWidth: 600,
//             minWidth: 300,
//             maxHeight: 300,
//             minHeight: 300,
//           ),
//           width: double.infinity,
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.folder_open,
//                 size: 48,
//                 color: theme.colorScheme.primary,
//               ),
//               const SizedBox(height: 12),
//               if (pickedFile == null)
//                 Text(
//                   textAlign: TextAlign.center,
//                   'Drag and drop files here \n or click to browse',
//                   style: theme.textTheme.bodyLarge,
//                 )
//               else
//                 Column(
//                   children: [
//                     Text(
//                       pickedFile.name,
//                       style: theme.textTheme.titleMedium,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       '${(pickedFile.size / 1024).toStringAsFixed(2)} KB',
//                       style: theme.textTheme.bodyMedium,
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
