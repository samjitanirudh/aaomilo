package com.sg.r79a.converge;

import android.os.Bundle;
import android.util.Log;

import com.example.ssoanywhere.controller.AutherizedResponseInterface;
import com.example.ssoanywhere.view.SSOAnywhere;

import java.util.Map;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "samples.flutter.dev/ssoanywhere";
    private SSOAnywhere ssoAnywhere;

    @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    ssoAnywhere = SSOAnywhere.getInstance(this, "Indec_QB", "272sqToLimhvjkzFNFpA", new AutherizedResponseInterface() {
            @Override
            public void getResponse(String jsonresult, boolean fromRefreshAPI) {
            }

            @Override
            public void getErrorResponse(int responseCode) {
            }
    });
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                  final Map map = call.argument("credentials");
                  if (call.method.equals("getAccessToken")) {
                      getAccessToken(map.get("username").toString(), map.get("password").toString(), result);
                  } else if (call.method.equals("getRefreshToken")) {
                      getRefreshToken(result);
                  }else if (call.method.equals("isLoggedIn")) {
                      isLoggedIn(result);
                  } else {
                      result.notImplemented();
                  }
              }
            });
  }


   private  void getAccessToken(String username , String password , MethodChannel.Result result){
    ssoAnywhere = SSOAnywhere.getInstance(this,"Indec_QB","272sqToLimhvjkzFNFpA", new AutherizedResponseInterface() {
        @Override
        public void getResponse(String jsonresult, boolean fromRefreshAPI) {
            result.success(jsonresult);
        }

        @Override
        public void getErrorResponse(int responseCode) {
            result.error(String.valueOf(responseCode), "Resource owner authentication failed", null);
        }
    });
    ssoAnywhere.callingAutherizeAPI(username,password);
   }
    private  void isLoggedIn(MethodChannel.Result result){
        if(null!=ssoAnywhere)
            result.success(ssoAnywhere.isLoggedIn());
        else
            result.error("Error ", "null object", ssoAnywhere.isLoggedIn());

    }

    private  void getRefreshToken(MethodChannel.Result result){
        ssoAnywhere = SSOAnywhere.getInstance(this,"Indec_QB","272sqToLimhvjkzFNFpA", new AutherizedResponseInterface() {
            @Override
            public void getResponse(String jsonresult, boolean fromRefreshAPI) {
                result.success(jsonresult);
            }

            @Override
            public void getErrorResponse(int responseCode) {
                result.error(String.valueOf(responseCode), "Resource owner authentication failed", null);
            }
        });
        ssoAnywhere.callingRefreshTokenAPI();
    }
//  private fun getAccessToken(result):Unit{
//    var jsonResponse : String = "";
//    val ssoAnywhere = SSOAnywhere.getInstance(this,"Indec_QB","272sqToLimhvjkzFNFpA",object : AutherizedResponseInterface{
//      override fun getResponse(jsonresult: String?, fromRefreshAPI: Boolean) {
//        result.success(jsonresult)
//      }
//
//      override fun getErrorResponse(responseCode: Int) {
//        result.error("UNAVAILABLE", responseCode.toString() + "AccessToken not available.", null)
//      }
//
//    })
//    ssoAnywhere.callingAutherizeAPI("K1478711","K_1478711")
//
//  }

}
