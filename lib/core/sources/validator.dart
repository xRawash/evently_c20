class Validator{
  static String?validateName(String? name){
    if(name == null || name.trim().isEmpty){
      return "Name is required";
    }
    if(name.length < 6){
      return "Sorry, name should be at least 6 chars";
    }
    return null;
  }

  static String? validateEmail(String? email){
    RegExp emailExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (email == null || email.trim().isEmpty) {
      return "Email is required";
    } else if (!emailExp.hasMatch(email)) {
      return "Email Bad Format";
    }
    return null;
  }


  static String? validatePassword(String? password){
   RegExp passwordExp =  RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );
    if (password == null || password.trim().isEmpty) {
      return "Sorry, required password";
    } else if (password.length < 6) {
      return "Sorry, Password should be at least 6 chars";
    } else if (!passwordExp.hasMatch(password)) {
      return "Weak Password";
    }
  }
}