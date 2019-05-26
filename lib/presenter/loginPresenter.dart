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
      if(response!=null) {
        _callbacks.loginSuccessfull();
      }
    }on Exception catch(error) {
      _callbacks.showLoginError();
    }
  }
}

abstract class LoginCallbacks {
  void loginSuccessfull();
  void showLoginError();
}
