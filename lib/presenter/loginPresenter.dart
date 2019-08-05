import 'package:flutter_meetup_login/viewmodel/LoginModel.dart';

class LoginPresenter {
  LoginCallbacks _callbacks;
  LoginModel _loginModel;

  LoginPresenter(LoginCallbacks callbacks) {
    this._loginModel = new LoginModel();
    this._callbacks = callbacks;
  }

  loginButtonOnClick(String uName, String pwd) async {
    try{
      String response = await _loginModel.checkLogin(uName, pwd);
      if(response!=null && !response.contains("Error : ")) {
        _callbacks.loginSuccessfull(response);
      }
      else{
        _callbacks.showLoginError(response);
      }
    }on Exception catch(error) {
      _callbacks.showLoginError(error.toString());
    }
  }

}

abstract class LoginCallbacks {
  void loginSuccessfull(String response);
  void showLoginError(String error_response);
}
