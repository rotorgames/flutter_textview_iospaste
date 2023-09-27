import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class PastComponent extends StatefulWidget {
  final Function(String pasted) onPasted;

  const PastComponent({
    super.key,
    required this.onPasted,
  });

  @override
  State<PastComponent> createState() => _PastComponentState();
}

class _PastComponentState extends State<PastComponent> {
  late final MethodChannel channel;

  @override
  void initState() {
    super.initState();

    channel = const MethodChannel("uipastecomponent")
      ..setMethodCallHandler(_onMethodCall);
  }

  @override
  Widget build(BuildContext context) {
    const String viewType = 'paste_component';
    // Pass parameters to the platform side.
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return UiKitView(
      viewType: viewType,
      layoutDirection: TextDirection.ltr,
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      hitTestBehavior: PlatformViewHitTestBehavior.translucent,
    );
  }

  Future _onMethodCall(MethodCall call) {
    switch (call.method) {
      case "pasted":
        widget.onPasted(call.arguments);
        break;
      default:
    }

    return Future.value();
  }
}
