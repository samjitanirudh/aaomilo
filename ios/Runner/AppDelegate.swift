import UIKit
import Flutter
import SSOAnywhereLib
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool
  {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let ssoAnywhereChannel = FlutterMethodChannel(name: "samples.flutter.dev/ssoanywhere",
                                                  binaryMessenger: controller as! FlutterBinaryMessenger)
    GeneratedPluginRegistrant.register(with: self)
    SSOAnyWhere.shared.Setup(clientID:"Indec_QB" , clientSecret:"272sqToLimhvjkzFNFpA")
    
    ssoAnywhereChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
//       dataMap = call.arguments("credentials") as! NSDictionary
        if ("getAccessToken" == call.method)
        {
            //var temp :Dictionary<String,String> = [:]
            let arguments = call.arguments as! NSDictionary
            let argue = arguments["credentials"] as! NSDictionary
            //temp = call.argum
            self?.getAccessToken(_username: argue["username"] as! String  , _password: argue["password"] as! String , result: result) // INFO: method call
        }
        else if ("isLoggedIn" == call.method) {
          self?.isLoggedIn(result: result)
        }
        else if("getRefreshToken" == call.method){
            self?.getRefreshToken(result: result)
        }
        else if("deleteSession" == call.method){
            self?.deleteSession(result: result)
        }
        else {
            result(FlutterMethodNotImplemented)
        }
    })
   
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func getAccessToken(_username: String, _password: String , result:@escaping FlutterResult) {
        SSOAnyWhere.callingAutherizeAPI(userName: _username, password: _password) {   response in
            if response.1 == Result.success {
                let jsonData = try? JSONSerialization.data(withJSONObject: response.0, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                result(jsonString)
            } else {
                result(FlutterError(code:"UNAVAILABLE",message:"Please check credentials",details:nil))
            }
        }
    }
    private func isLoggedIn(result: FlutterResult) {
        result(SSOAnyWhere.shared.isLoggedIn())
    }
    
    private func deleteSession(result: FlutterResult) {
        SSOAnyWhere.shared.deleteAllKeysInSession()
        result("Success")
    }
    private func getRefreshToken(result: @escaping FlutterResult) {
        SSOAnyWhere.callingRefreshAutherizeAPI{   Response in
            if Response.1 == Result.success {
                let jsonData = try? JSONSerialization.data(withJSONObject: Response.0, options: [])
                let jsonString = String(data: jsonData!, encoding: .utf8)
                result(jsonString)
            } else {
                result(FlutterError(code:"UNAVAILABLE",message:"Please check credentials",details:nil))
            }
        }
    }
}
