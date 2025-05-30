class UserStats {
  final int totalPoints;
  final int itemsRecycled;
  final int itemsSold;
  final int itemsDonated;
  final List<Map<String, dynamic>> recentActivities;
  final List<Map<String, dynamic>> availableRewards;

  UserStats({
    this.totalPoints = 0,
    this.itemsRecycled = 0,
    this.itemsSold = 0,
    this.itemsDonated = 0,
    List<Map<String, dynamic>>? recentActivities,
    List<Map<String, dynamic>>? availableRewards,
  })  : recentActivities = recentActivities ?? [],
        availableRewards = availableRewards ?? [];

  Map<String, dynamic> toMap() {
    return {
      'totalPoints': totalPoints,
      'itemsRecycled': itemsRecycled,
      'itemsSold': itemsSold,
      'itemsDonated': itemsDonated,
      'recentActivities': recentActivities,
      'availableRewards': availableRewards,
    };
  }

  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalPoints: map['totalPoints'] ?? 0,
      itemsRecycled: map['itemsRecycled'] ?? 0,
      itemsSold: map['itemsSold'] ?? 0,
      itemsDonated: map['itemsDonated'] ?? 0,
      recentActivities:
          List<Map<String, dynamic>>.from(map['recentActivities'] ?? []),
      availableRewards:
          List<Map<String, dynamic>>.from(map['availableRewards'] ?? []),
    );
  }

  UserStats copyWith({
    int? totalPoints,
    int? itemsRecycled,
    int? itemsSold,
    int? itemsDonated,
    List<Map<String, dynamic>>? recentActivities,
    List<Map<String, dynamic>>? availableRewards,
  }) {
    return UserStats(
      totalPoints: totalPoints ?? this.totalPoints,
      itemsRecycled: itemsRecycled ?? this.itemsRecycled,
      itemsSold: itemsSold ?? this.itemsSold,
      itemsDonated: itemsDonated ?? this.itemsDonated,
      recentActivities: recentActivities ?? this.recentActivities,
      availableRewards: availableRewards ?? this.availableRewards,
    );
  }
}
