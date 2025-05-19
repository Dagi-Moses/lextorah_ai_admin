enum UserRole {
  admin,
  student,
  trial,
  unknown, // fallback
}

extension UserRoleMapper on UserRole {
  String get name {
    switch (this) {
      case UserRole.admin:
        return 'admin';
      case UserRole.student:
        return 'student';
      case UserRole.trial:
        return 'trial';
      default:
        return 'unknown';
    }
  }

  bool get isAdmin => this == UserRole.admin;
  bool get isStudent => this == UserRole.student;
  bool get isTrial => this == UserRole.trial;
}

UserRole userRoleFromString(String? role) {
  switch (role?.toLowerCase()) {
    case 'admin':
      return UserRole.admin;
    case 'student':
      return UserRole.student;
    case 'trial':
      return UserRole.trial;
    default:
      return UserRole.unknown;
  }
}
