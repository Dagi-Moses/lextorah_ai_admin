import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lextorah_chat_bot/hive/uploaded_file_hive_model.dart';
import 'package:lextorah_chat_bot/providers/uploaded_files_provider.dart';
import 'package:lextorah_chat_bot/utils/format_timestamp.dart';

class UploadedFilesTable extends ConsumerWidget {
  const UploadedFilesTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch the uploaded files provider to get the list of files
    final uploadedFiles = [...ref.watch(uploadedFilesProvider)]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp)); // Sort descending

    // If no files are uploaded, return an empty box (or a message if preferred)
    if (uploadedFiles.isEmpty) {
      return const SizedBox.shrink(); // or Text('No files uploaded')
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: DataTable(
            columnSpacing: 32,
            horizontalMargin: 24,
            columns: const [
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Uploaded')),
              DataColumn(label: Text('Status')),
            ],
            rows:
                uploadedFiles.map((file) {
                  return _fileRow(
                    file.name,
                    formatTimestamp(file.timestamp),
                    file.status.label,
                    file.status == UploadStatus.success
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  DataRow _fileRow(String name, String uploaded, String status, Color color) {
    return DataRow(
      cells: [
        DataCell(Text(name, overflow: TextOverflow.ellipsis)),
        DataCell(Text(uploaded)),
        DataCell(
          Text(
            status,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

// import 'dart:ui';

// import 'package:flutter/material.dart';

// class UploadedFilesTable extends StatelessWidget {
//   const UploadedFilesTable({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal, // Prevent overflow on smaller screens
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 10),
//         child: SizedBox(
//           width:
//               MediaQuery.of(context).size.width, // Make it stretch full width
//           child: DataTable(
//             columnSpacing: 32,
//             horizontalMargin: 24,

//             columns: const [
//               DataColumn(label: Text('Name')),
//               DataColumn(label: Text('Uploaded')),
//               DataColumn(label: Text('Status')),
//             ],
//             rows: [
//               _fileRow(
//                 'Curriculum.pdf',
//                 'Today',
//                 'Success',
//                 theme.colorScheme.primary,
//               ),
//               _fileRow(
//                 'Rules.pdf',
//                 'Yesterday',
//                 'Success',
//                 theme.colorScheme.primary,
//               ),
//               _fileRow(
//                 'Policy.pdf',
//                 '04/22/2024',
//                 'Failed',
//                 theme.colorScheme.error,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   DataRow _fileRow(String name, String uploaded, String status, Color color) {
//     return DataRow(
//       cells: [
//         DataCell(Text(name)),
//         DataCell(Text(uploaded)),
//         DataCell(
//           Text(
//             status,
//             style: TextStyle(color: color, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ],
//     );
//   }
// }
