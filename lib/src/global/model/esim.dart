class EsimProduct {
  final String id;
  final String days;
  final String gigas;
  final String destiny;
  final String description;
  final List<EsimPrice> prices;
  final List<Metadata> metadata;
  final String productIdB2B;
  final String productIdB2C;
  final String variantIdB2B;
  final String variantIdB2C;

  EsimProduct({
    required this.id,
    required this.days,
    required this.gigas,
    required this.destiny,
    required this.description,
    required this.prices,
    required this.metadata,
    required this.productIdB2B,
    required this.productIdB2C,
    required this.variantIdB2B,
    required this.variantIdB2C,
  });

  factory EsimProduct.fromJson(Map<String, dynamic> json) {
    return EsimProduct(
      id: json['id'] ?? '',
      days: json['days'] ?? '',
      gigas: json['gigas'] ?? '',
      destiny: json['destiny'] ?? '',
      description: json['description'] ?? '',
      prices: (json['prices'] as List<dynamic>? ?? [])
          .map((e) => EsimPrice.fromJson(e))
          .toList(),
      metadata: (json['metadata'] as List<dynamic>? ?? [])
          .map((e) => Metadata.fromJson(e))
          .toList(),
      productIdB2B: json['productIdB2B'] ?? '',
      productIdB2C: json['productIdB2C'] ?? '',
      variantIdB2B: json['variantIdB2B'] ?? '',
      variantIdB2C: json['variantIdB2C'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'days': days,
      'gigas': gigas,
      'destiny': destiny,
      'description': description,
      'prices': prices.map((e) => e.toJson()).toList(),
      'metadata': metadata.map((e) => e.toJson()).toList(),
      'productIdB2B': productIdB2B,
      'productIdB2C': productIdB2C,
      'variantIdB2B': variantIdB2B,
      'variantIdB2C': variantIdB2C,
    };
  }
}

class EsimPrice {
  final String currency;
  final String amount;

  EsimPrice({
    required this.currency,
    required this.amount,
  });

  factory EsimPrice.fromJson(Map<String, dynamic> json) {
    return EsimPrice(
      currency: json['currency'] ?? '',
      amount: json['amount'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'amount': amount,
    };
  }
}

class Metadata {
  final String name;
  final String value;

  Metadata({
    required this.name,
    required this.value,
  });

  factory Metadata.fromJson(Map<String, dynamic> json) {
    return Metadata(
      name: json['name'] ?? '',
      value: json['value'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'value': value,
    };
  }
}