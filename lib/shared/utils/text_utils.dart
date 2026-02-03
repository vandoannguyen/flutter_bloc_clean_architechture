class TextUtils {
  static RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$");

  static String? validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) return "Email không đươc trống";
    if (!emailRegex.hasMatch(email)) return "Email k ddungs didnhj dangj";
    return null;
  }
}
