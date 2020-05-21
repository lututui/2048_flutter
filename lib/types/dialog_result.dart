import 'package:flutter/material.dart';

/// A option shown in a dialog
class DialogOption {
  DialogOption._(this.icon);

  /// An icon associated with this [DialogOption]
  final IconData icon;

  /// Pause/Unpause option
  static DialogOption pause = DialogOption._(Icons.pause);

  /// Reset option
  static DialogOption reset = DialogOption._(Icons.settings_backup_restore);

  /// Exit/Back option
  static DialogOption exit = DialogOption._(Icons.keyboard_backspace);
}
