import UIKit
import Flutter
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.window.makeSecure()
    GeneratedPluginRegistrant.register(with: self)
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

//   override func applicationWillResignActive(
//       _ application: UIApplication
//     ) {
//       self.window.isHidden = true;
//     }
//     override func applicationDidBecomeActive(
//       _ application: UIApplication
//     ) {
//       self.window.isHidden = false;
//     }
}
private func registerPlugins(registry: FlutterPluginRegistry) {
      if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
         FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
      }
  }
extension UIWindow {
func makeSecure() {
    let field = UITextField()
    field.isSecureTextEntry = true
    self.addSubview(field)
    field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.layer.superlayer?.addSublayer(field.layer)
    field.layer.sublayers?.first?.addSublayer(self.layer)
  }
}
