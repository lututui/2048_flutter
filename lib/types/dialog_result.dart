import 'package:flutter/material.dart';

enum DialogResult { RESUME, RESET, EXIT }

extension DialogResultIcons on DialogResult {
  IconData get icon {
    switch (this) {
      case DialogResult.RESUME:
        return Icons.pause;
      case DialogResult.RESET:
        return Icons.settings_backup_restore;
      case DialogResult.EXIT:
        return Icons.keyboard_backspace;
    }

    return Icons.error;
  }
}