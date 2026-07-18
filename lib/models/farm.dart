import 'package:flutter/material.dart';

enum CropType { maize, tomato, avocado, tea, poultry, coffee, honey }

extension CropTypeX on CropType {
  String get label {
    switch (this) {
      case CropType.maize:
        return 'Maize';
      case CropType.tomato:
        return 'Tomato';
      case CropType.avocado:
        return 'Avocado';
      case CropType.tea:
        return 'Tea';
      case CropType.poultry:
        return 'Poultry';
      case CropType.coffee:
        return 'Coffee';
      case CropType.honey:
        return 'Honey';
    }
  }

  Color get swatch {
    switch (this) {
      case CropType.maize:
        return const Color(0xFFE8D9A8);
      case CropType.tomato:
        return const Color(0xFFE0A98B);
      case CropType.avocado:
        return const Color(0xFFC9D9B0);
      case CropType.tea:
        return const Color(0xFFB9D2B4);
      case CropType.poultry:
        return const Color(0xFFEAD9C4);
      case CropType.coffee:
        return const Color(0xFFC7B299);
      case CropType.honey:
        return const Color(0xFFF0CC7A);
    }
  }
}

/// How an investor can be rewarded when a listing pays out.
enum RewardType { cashPayout, physicalProduct }

extension RewardTypeX on RewardType {
  String get label {
    switch (this) {
      case RewardType.cashPayout:
        return 'Cash payout (M-Pesa)';
      case RewardType.physicalProduct:
        return 'Actual product';
    }
  }

  IconData get icon {
    switch (this) {
      case RewardType.cashPayout:
        return Icons.payments;
      case RewardType.physicalProduct:
        return Icons.inventory_2;
    }
  }
}

class Farm {
  final String id;
  final String name;
  final String location;
  final CropType crop;
  final int targetKes;
  final int weeks;
  final double fundedFraction; // 0.0 - 1.0
  final double estReturnPct; // annualised-ish illustrative return
  final String summary;
  final bool iotVerified;
  final bool fieldVerified;
  final String imageUrl;
  final List<RewardType> rewardTypes;
  final String? productRewardDescription;
  final bool carbonCreditEligible;

  const Farm({
    required this.id,
    required this.name,
    required this.location,
    required this.crop,
    required this.targetKes,
    required this.weeks,
    required this.fundedFraction,
    required this.estReturnPct,
    required this.summary,
    this.iotVerified = true,
    this.fieldVerified = true,
    this.imageUrl = '',
    this.rewardTypes = const [RewardType.cashPayout],
    this.productRewardDescription,
    this.carbonCreditEligible = false,
  });

  bool get supportsProductReward => rewardTypes.contains(RewardType.physicalProduct);

  String get formattedTarget {
    final s = targetKes.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(',');
    }
    return 'KES ${buf.toString()}';
  }
}
