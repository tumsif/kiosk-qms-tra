class Service {
  final String id;
  final String name;
  final bool requireUserData;
  final String? iconUrl;
  final List<Block> blocks;

  Service({
    required this.id,
    required this.name,
    required this.requireUserData,
    required this.blocks,
    required this.iconUrl,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'].toString(),
      name: json['name'].toString(),
      iconUrl: json['icon_url']?.toString(),
      requireUserData: json['require_user_data'] ?? false,
      blocks: (json['blocks'] as List).map((b) => Block.fromJson(b)).toList(),
    );
  }
}

class Block {
  final String id;
  final String name;

  Block({
    required this.id,
    required this.name,
  });

  factory Block.fromJson(Map<String, dynamic> json) {
    return Block(
      id: json['id'].toString(),
      name: json['name'].toString(),
    );
  }
}