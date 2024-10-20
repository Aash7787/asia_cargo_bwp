import 'dart:convert';

class Bilty {
  int biltyNumber;
  String biltyUrl;
  Bilty({
    required this.biltyNumber,
    required this.biltyUrl,
  });

  Bilty copyWith({
    int? biltyNumber,
    String? biltyUrl,
  }) {
    return Bilty(
      biltyNumber: biltyNumber ?? this.biltyNumber,
      biltyUrl: biltyUrl ?? this.biltyUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'biltyNumber': biltyNumber,
      'biltyUrl': biltyUrl,
    };
  }

  factory Bilty.fromMap(Map<String, dynamic> map) {
    return Bilty(
      biltyNumber: map['biltyNumber']?.toInt() ?? 0.0,
      biltyUrl: map['biltyUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Bilty.fromJson(String source) => Bilty.fromMap(json.decode(source));

  @override
  String toString() => 'Student(biltyNumber: $biltyNumber, biltyUrl: $biltyUrl)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Bilty &&
      other.biltyNumber == biltyNumber &&
      other.biltyUrl == biltyUrl;
  }

  @override
  int get hashCode => biltyNumber.hashCode ^ biltyUrl.hashCode;
}
