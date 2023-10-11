import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class FunctionUtils {
  static final FunctionUtils _instance = FunctionUtils._();

  FunctionUtils._();

  static FunctionUtils get instance => _instance;

  static FunctionUtils getInstance() {
    return _instance;
  }

  OverlaySupportEntry? showSimpleNotification(
    Widget content, {
    /**
         * See more [ListTile.leading].
         */
    Widget? leading,
    /**
         * See more [ListTile.subtitle].
         */
    Widget? subtitle,
    /**
         * See more [ListTile.trailing].
         */
    Widget? trailing,
    /**
         * See more [ListTile.contentPadding].
         */
    EdgeInsetsGeometry? contentPadding,
    /**
         * The background color for notification, default to [ThemeData.colorScheme.secondary].
         */
    Color? background: Colors.transparent,
    /**
         * See more [ListTileTheme.textColor],[ListTileTheme.iconColor].
         */
    Color? foreground,
    /**
         * The elevation of notification, see more [Material.elevation].
         */
    double elevation = 16,
    Duration? duration,
    Key? key,
    /**
         * True to auto hide after duration [kNotificationDuration].
         */
    bool autoDismiss = true,
    /**
         * Support left/right to dismiss notification.
         */
    @Deprecated("use slideDismissDirection instead") bool slideDismiss = false,
    /**
         * The position of notification, default is [NotificationPosition.top],
         */
    NotificationPosition position = NotificationPosition.top,
    BuildContext? context,
    /**
         * The direction in which the notification can be dismissed.
         */
    DismissDirection? slideDismissDirection: DismissDirection.up,
  }) {
    final dismissDirection = slideDismissDirection ?? (slideDismiss
            ? DismissDirection.horizontal
            : DismissDirection.none);
    final entry = showOverlayNotification(
      (context) {
        return SlideDismissible(
          direction: dismissDirection,
          key: ValueKey(key),
          child: Material(
            color: background ?? Theme.of(context).colorScheme.secondary,
            elevation: elevation,
            child: ListTileTheme(
              textColor:
                  foreground ?? Theme.of(context).textTheme.headline6?.color,
              iconColor:
                  foreground ?? Theme.of(context).textTheme.headline6?.color,
              child: ListTile(
                leading: leading,
                title: content,
                subtitle: subtitle,
                trailing: trailing,
                contentPadding: contentPadding ?? const EdgeInsets.all(0),
              ),
            ),
          ),
        );
      },
      duration: autoDismiss ? duration : const Duration(seconds: 3),
      key: key,
      position: position,
      context: context,
    );
    return entry;
  }
}
