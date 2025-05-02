import 'package:hive/hive.dart';

part 'uploaded_file_hive_model.g.dart';

@HiveType(typeId: 0)
class UploadedFileHiveModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final UploadStatus status;

  @HiveField(2)
  final int timestamp;

  UploadedFileHiveModel({
    required this.name,
    required this.status,
    required this.timestamp,
  });
}

class UploadStatusAdapter extends TypeAdapter<UploadStatus> {
  @override
  final int typeId = 1;

  @override
  UploadStatus read(BinaryReader reader) {
    return UploadStatus.values[reader.readByte()];
  }

  @override
  void write(BinaryWriter writer, UploadStatus obj) {
    writer.writeByte(obj.index);
  }
}

enum UploadStatus { success, failed }

extension UploadStatusExtension on UploadStatus {
  String get label {
    switch (this) {
      case UploadStatus.success:
        return "Success";
      case UploadStatus.failed:
        return "Failed";
    }
  }

  // You can also reverse the string back to the enum if needed
  static UploadStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return UploadStatus.success;
      case 'failed':
        return UploadStatus.failed;
      default:
        throw ArgumentError('Unknown status: $status');
    }
  }
}
