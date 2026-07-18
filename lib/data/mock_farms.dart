import '../models/farm.dart';

final List<Farm> mockFarms = [
  const Farm(
    id: 'kericho-tea',
    name: 'Kericho Tea Farm',
    location: 'Kericho',
    crop: CropType.tea,
    targetKes: 180000,
    weeks: 14,
    fundedFraction: 0.72,
    estReturnPct: 11,
    summary:
        'A 4-acre smallholder tea plot upgrading to higher-yield clones, '
        'with plucking wages covered through the next two harvest cycles.',
    imageUrl:
        'https://images.unsplash.com/photo-1563822249366-9556b1173b1b?auto=format&fit=crop&w=800&q=60',
    rewardTypes: [RewardType.cashPayout],
    carbonCreditEligible: true,
  ),
  const Farm(
    id: 'machakos-poultry',
    name: 'Machakos Poultry',
    location: 'Machakos',
    crop: CropType.poultry,
    targetKes: 95000,
    weeks: 8,
    fundedFraction: 0.45,
    estReturnPct: 9,
    summary:
        'A layer-hen expansion funding feed, vaccines and a second coop, '
        'with eggs sold weekly to three verified local buyers.',
    imageUrl:
        'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=800&q=60',
    rewardTypes: [RewardType.cashPayout],
  ),
  const Farm(
    id: 'nyeri-coffee',
    name: 'Nyeri Coffee Farm',
    location: 'Nyeri',
    crop: CropType.coffee,
    targetKes: 250000,
    weeks: 20,
    fundedFraction: 0.30,
    estReturnPct: 13,
    summary:
        'Arabica smallholder cooperative plot financing pulping equipment '
        'ahead of the main harvest, with proceeds routed via the co-op.',
    imageUrl:
        'https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=800&q=60',
    rewardTypes: [RewardType.cashPayout, RewardType.physicalProduct],
    productRewardDescription:
        '250g bag of roasted Nyeri AA coffee per KES 1,000 invested, '
        'delivered after the main harvest instead of a cash payout.',
    carbonCreditEligible: true,
  ),
  const Farm(
    id: 'kiambu-maize',
    name: 'Kiambu Maize Farm',
    location: 'Kiambu',
    crop: CropType.maize,
    targetKes: 120000,
    weeks: 12,
    fundedFraction: 0.58,
    estReturnPct: 10,
    summary:
        'Short-cycle maize on a 3-acre plot, funding certified seed and '
        'fertiliser ahead of the long-rains planting window.',
    imageUrl:
        'https://images.unsplash.com/photo-1601472777005-c53ed4b8c9c7?auto=format&fit=crop&w=800&q=60',
    rewardTypes: [RewardType.cashPayout],
  ),
  const Farm(
    id: 'nakuru-tomato',
    name: 'Nakuru Tomato Farm',
    location: 'Nakuru',
    crop: CropType.tomato,
    targetKes: 140000,
    weeks: 10,
    fundedFraction: 0.81,
    estReturnPct: 12,
    summary:
        'Greenhouse tomato restock funding seedlings and drip-irrigation '
        'repair, sold through an established Nakuru market contract.',
    imageUrl:
        'https://images.unsplash.com/photo-1592841200221-a6898f307baa?auto=format&fit=crop&w=800&q=60',
    rewardTypes: [RewardType.cashPayout],
  ),
  const Farm(
    id: 'meru-avocado',
    name: 'Meru Avocado Farm',
    location: 'Meru',
    crop: CropType.avocado,
    targetKes: 210000,
    weeks: 18,
    fundedFraction: 0.64,
    estReturnPct: 14,
    summary:
        'Hass avocado smallholder plot funding export-grade grading and '
        'transport ahead of a contracted export order.',
    imageUrl:
        'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?auto=format&fit=crop&w=800&q=60',
    rewardTypes: [RewardType.cashPayout],
    carbonCreditEligible: true,
  ),
  const Farm(
    id: 'baringo-beehive',
    name: 'Baringo Bee Hive Collective',
    location: 'Baringo',
    crop: CropType.honey,
    targetKes: 130000,
    weeks: 16,
    fundedFraction: 0.38,
    estReturnPct: 15,
    summary:
        'A 40-hive apiary expansion along the Tugen Hills, funding new '
        'Langstroth hives, protective gear and extraction equipment for a '
        'beekeeping cooperative selling raw honey and beeswax locally.',
    imageUrl:
        'https://images.unsplash.com/photo-1568526381923-caf3fd520382?auto=format&fit=crop&w=800&q=60',
    rewardTypes: [RewardType.cashPayout, RewardType.physicalProduct],
    productRewardDescription:
        '500ml jar of raw Baringo wildflower honey per KES 500 invested, '
        'delivered straight from the hive instead of a cash payout.',
    carbonCreditEligible: true,
  ),
];

class ImpactStat {
  final String value;
  final String label;
  const ImpactStat(this.value, this.label);
}

const List<ImpactStat> impactStats = [
  ImpactStat('33%', "of Kenya's GDP is agriculture"),
  ImpactStat('4M+', 'urban youth (18–35) locked out'),
  ImpactStat('40%', 'post-harvest losses from underfunding'),
  ImpactStat('\$200B', 'global agri-financing gap'),
];
