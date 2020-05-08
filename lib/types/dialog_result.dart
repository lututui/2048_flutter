import 'package:flutter/material.dart';

enum DialogResult { pause, reset, exit }

extension DialogResultIcons on DialogResult {
  IconData get icon {
    switch (this) {
      case DialogResult.pause:
        return Icons.pause;
      case DialogResult.reset:
        return Icons.settings_backup_restore;
      case DialogResult.exit:
        return Icons.keyboard_backspace;
    }

    return Icons.error;
  }
}
