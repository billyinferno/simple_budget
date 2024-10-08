class UserLoginInfoModel {
  final int id;
  final String username;
  final String email;
  final bool confirmed;
  final bool blocked;
  final int risk;
  final bool visibility;
  final bool showLots;
  final String bot;
  final bool showEmptyWatchlist;

  UserLoginInfoModel({required this.id, required this.username, required this.email, required this.confirmed, required this.blocked, required this.risk, required this.visibility, required this.showLots, required this.bot, required this.showEmptyWatchlist});

  factory UserLoginInfoModel.fromJson(Map<String, dynamic> json) {
    return UserLoginInfoModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      risk: (json['risk'] ?? 10),
      visibility: (json['visibility'] ?? false),
      showLots: (json['show_lots'] ?? false),
      bot: (json['bot'] ?? ''),
      showEmptyWatchlist: (json['show_empty_watchlist'] ?? true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'confirmed': confirmed,
      'blocked': blocked,
      'risk': risk,
      'visibility': visibility,
      'show_lots': showLots,
      'bot': bot,
      'show_empty_watchlist': showEmptyWatchlist
    };
  }
}