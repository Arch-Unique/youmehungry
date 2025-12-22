class Card {
  int id;
  int? cardType;
  String? cardAlias;
  String? cardFullname;
  String? cardNumber;
  String? cardExpiry;
  String? cardVcc;
  String? cardAddress;
  String? cardZipcode;
  String? pin;
  String? cardId;
  double cardBalance;
  bool isFrozen;
  bool isDeleted;
  String? status;
  int? walletId;
  Map<String, dynamic>? userData;
  DateTime? updatedAt;
  DateTime? createdAt;

  Card({
    this.id = 0,
    this.cardType,
    this.cardAlias,
    this.cardFullname,
    this.cardNumber,
    this.cardExpiry,
    this.cardVcc,
    this.cardAddress,
    this.cardZipcode,
    this.pin,
    this.cardId,
    this.cardBalance = 0.0,
    this.isFrozen = false,
    this.isDeleted = false,
    this.status,
    this.walletId,
    this.updatedAt,
    this.createdAt,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      id: json['id'],
      cardType: json['cardtype'],
      cardAlias: json['cardalias'],
      cardFullname: json['cardfullname'],
      cardNumber: json['cardnumber'],
      cardExpiry: json['cardexpiry'],
      cardVcc: json['cardvcc'],
      cardAddress: json['cardaddress'],
      cardZipcode: json['cardzipcode'],
      pin: json['pin'],
      cardId: json['cardid'],
      cardBalance: json['cardbalance']?.toDouble() ?? 0.0,
      isFrozen: json['isfrozen'] ?? false,
      isDeleted: json['isdeleted'] ?? false,
      status: json['status'],
      walletId: json['walletid'],
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'cardtype': cardType,
        'cardalias': cardAlias,
        'cardfullname': cardFullname,
        'cardnumber': cardNumber,
        'cardexpiry': cardExpiry,
        'cardvcc': cardVcc,
        'cardaddress': cardAddress,
        'cardzipcode': cardZipcode,
        'pin': pin,
        'cardid': cardId,
        'cardbalance': cardBalance,
        'isfrozen': isFrozen,
        'isdeleted': isDeleted,
        'status': status,
        'walletid': walletId,
      };
}
