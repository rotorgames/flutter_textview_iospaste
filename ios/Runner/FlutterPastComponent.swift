//
//  FlutterPastComponent.swift
//  Runner
//
//  Created by Kirill Lyubimov on 26/9/2023.
//

import Foundation
import Flutter
import UIKit

class FLNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
          return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, UIPasteConfigurationSupporting, FlutterPlatformView {
    var pasteConfiguration: UIPasteConfiguration?
    var currentMessenger: FlutterBinaryMessenger?
    var methodChannel: FlutterMethodChannel?
    
    private var _view: UIView

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView()
        currentMessenger = messenger
        methodChannel = FlutterMethodChannel(name: "uipastecomponent", binaryMessenger: currentMessenger!)
        super.init()
        // iOS views can be created here
        createNativeView(view: _view)
    }

    func view() -> UIView {
        return _view
    }
    
    func canPaste(_ itemProviders: [NSItemProvider]) -> Bool {
        true
    }
    
    func paste(itemProviders: [NSItemProvider]) {
        if let pastedText = UIPasteboard.general.string {
            methodChannel!.invokeMethod("pasted", arguments: pastedText)
        }
    }

    func createNativeView(view _view: UIView){
        if #available(iOS 16.0, *) {
            let textView = UITextView()
            
            let configuration = UIPasteControl.Configuration()
            configuration.baseBackgroundColor = UIColor(red: 246/255.0, green: 246/255.0, blue: 246/255.0, alpha: 1) // Makes color closer to AdaptiveTextSelectionToolbar
            configuration.baseForegroundColor = UIColor(white: 0, alpha: 1)
            configuration.cornerStyle = .fixed
            configuration.displayMode = .labelOnly
                                
            let pasteButton = UIPasteControl(configuration: configuration)
            pasteButton.frame = CGRect(x: 0, y: 0, width: 70, height: 34) //TODO Support Flutter's widget size
            _view.addSubview(pasteButton)
            
            pasteButton.target = self
        } else {
            // Fallback on earlier versions
        }
    }
}
