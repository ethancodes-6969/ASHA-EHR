import 'package:flutter/material.dart';
import 'package:asha_ehr/presentation/theme/semantic_colors.dart';

enum RiskLevel { high, medium, low }

class RiskIndicator {
  static Color colorForLevel(RiskLevel level) {
    switch (level) {
      case RiskLevel.high:
        return SemanticColors.danger;
      case RiskLevel.medium:
        return SemanticColors.warning;
      case RiskLevel.low:
        return SemanticColors.success;
    }
  }
}
