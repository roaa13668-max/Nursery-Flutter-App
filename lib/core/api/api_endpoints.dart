class ApiEndpoints {
  // Authentication
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';

  // Dashboard
  static const String dashboardSummary = '/dashboard/summary';

  // Children
  static const String children = '/children';
  static String childById(int id) => '/children/$id';

  // Teachers
  static const String teachers = '/teachers';
  static String teacherById(int id) => '/teachers/$id';

  // Classrooms
  static const String classrooms = '/classrooms';
  static String classroomById(int id) => '/classrooms/$id';

  // Attendance
  static const String attendance = '/attendance';
  static String attendanceByDate(String date) => '/attendance?date=$date';

  // Payments
  static const String payments = '/payments';
}