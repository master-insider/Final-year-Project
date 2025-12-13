// class ApiConstants {
//   // Replace with your Django backend base URL (use https in production)
//   static const String baseUrl = 'http://10.0.2.2:8000/api/'; // Android emulator -> localhost
//   static const Duration timeout = Duration(seconds: 30);
// }

class ApiConstants {
  // Replace with your Django backend base URL (use https in production)
  static const String baseUrl = 'http://127.0.0.1:8000/'; // Android emulator -> localhost
  static const Duration timeout = Duration(seconds: 30);
  static const String authRegister = "/api/auth/register/";
  static const String authLogin = "/api/auth/login/";
  static const String refreshToken = "/api/auth/refresh/";

  static const String expenses = "/api/expenses/";
  static String expenseDetails(int id) => "/api/expenses/$id/";

  static const String budgets = "/api/budgets/";
  static const String currentBudget = "/api/budgets/current/";

  static const String dashboardStats = "/api/dashboard/stats/";
  static const String dashboardRecent = "/api/dashboard/recent-expenses/";

  static const String insights = "/api/insights/";
  static const String reports = "/api/reports/";
}
