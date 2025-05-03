// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'uploaded_file_model.freezed.dart';
// part 'uploaded_file_model.g.dart';

// @freezed
// class UploadedFileModel with _$UploadedFileModel {
//   const factory UploadedFileModel({
//     required String name,
//     required String status,
//     @Default('') String uploaded, // Default value is an empty string
//     @Default(0) int timestamp, // Default value for timestamp
//   }) = _UploadedFileModel;

//   // Custom constructor for getting the current date and timestamp
//   factory UploadedFileModel.withDate({
//     required String name,
//     required String status,
//     DateTime? uploadedDate,
//   }) {
//     final now = uploadedDate ?? DateTime.now();
//     return UploadedFileModel(
//       name: name,
//       status: status,
//       uploaded: _formatDate(now),
//       timestamp: now.millisecondsSinceEpoch,
//     );
//   }

//   // Helper method to format the date to "yyyy-MM-dd"
//   static String _formatDate(DateTime dateTime) {
//     return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
//   }

//   // JSON serialization helpers
//   factory UploadedFileModel.fromJson(Map<String, dynamic> json) =>
//       _$UploadedFileModelFromJson(json);

//   @override
//   dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
// }

// // @JsonSerializable()
// // class UploadedFileModel {
// //   final String name;
// //   final String uploaded; // Store date in a human-readable format
// //   final String status; // e.g., "Success", "Failed"
// //   final int timestamp; // Store the timestamp as Unix milliseconds

// //   UploadedFileModel({
// //     required this.name,
// //     required this.status,
// //     DateTime? uploadedDate,
// //   }) : uploaded =
// //            uploadedDate != null
// //                ? _formatDate(uploadedDate)
// //                : _formatDate(
// //                  DateTime.now(),
// //                ), // Use current date if not provided
// //        timestamp =
// //            uploadedDate?.millisecondsSinceEpoch ??
// //            DateTime.now().millisecondsSinceEpoch;

// //   factory UploadedFileModel.fromJson(Map<String, dynamic> json) =>
// //       _$UploadedFileModelFromJson(json);

// //   Map<String, dynamic> toJson() => _$UploadedFileModelToJson(this);

// //   // Helper method to format the date in the "Today" format or any desired format
// //   static String _formatDate(DateTime dateTime) {
// //     return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
// //   }
// // }
