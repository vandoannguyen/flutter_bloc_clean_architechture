import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    Key? key,
    this.width,
    this.height,
    this.backgroundColor = Colors.transparent,
    this.brightness = Brightness.light,
  }) : super(key: key);

  /// Width of loading
  final double? width;

  /// Height of loading
  final double? height;

  /// Color of background, default set to [Colors.transparent]
  final Color backgroundColor;

  /// Brightness of loading, default is [Brightness.light]
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Center(
        child: SizedBox(
          height: width ?? 40,
          width: height ?? 40,
          child: CupertinoTheme(
            data: CupertinoTheme.of(context).copyWith(
              brightness: brightness,
            ),
            child: const CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }
}
