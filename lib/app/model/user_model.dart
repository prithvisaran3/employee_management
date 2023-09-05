class UserModel {
  final String id;
  final String email;
  final String name;
  final int? department;
  final String employeeId;

  UserModel({
    required this.email,
    required this.name,
    this.department,
    required this.employeeId,
    required this.id,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
        email: data['email'],
        name: data['name'],
        employeeId: data['employee_id'],
        id: data['id'],
        department: data['department']);
  }
}
