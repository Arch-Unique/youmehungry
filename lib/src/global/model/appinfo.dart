class AppInfo {
  int id;
  String title;
  String? stringValue;
  double? numberValue;
  DateTime? updatedAt;
  DateTime? createdAt;

  AppInfo({
    this.id=0,
    required this.title,
    this.stringValue,
    this.numberValue,
    this.updatedAt,
    this.createdAt,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      id: json['id'],
      title: json['title'],
      stringValue: json['stringValue'],
      numberValue: json['numberValue']?.toDouble(),
      updatedAt: json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'stringValue': stringValue,
    'numberValue': numberValue,
    
  };
}