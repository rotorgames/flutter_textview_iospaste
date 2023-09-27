import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      
      weak var registrar = self.registrar(forPlugin: "paste_control_plugin")

      let factory = PasteComponentNativeViewFactory(messenger: registrar!.messenger())
      
      registrar!.register(
          factory,
          withId: "paste_component")
      
      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
