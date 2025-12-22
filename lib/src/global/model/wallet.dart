class Wallet {
  int id;
  String? bankName;
  String? bankAcct;
  String? bankCode;
  String? pin;
  String? orderRef;
  double bankBal;
  int userId;
  String? cardHolderId;
  String? status;
  DateTime? updatedAt;
  DateTime? createdAt;

  Wallet({
    this.id=0,
    this.bankName,
    this.bankAcct,
    this.bankCode,
    this.pin,
    this.orderRef,
    this.bankBal = 0.0,
    required this.userId,
    this.cardHolderId,
    this.status,
    this.updatedAt,
    this.createdAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      bankName: json['bankname'],
      bankAcct: json['bankacct'],
      bankCode: json['bankcode'],
      pin: json['pin'],
      orderRef: json['orderref'],
      bankBal: json['bankbal']?.toDouble() ?? 0.0,
      userId: json['userid'],
      cardHolderId: json['cardholderid'],
      status: json['status'],
      updatedAt: json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'bankname': bankName,
    'bankacct': bankAcct,
    'bankcode': bankCode,
    'pin': pin,
    'orderref': orderRef,
    'bankbal': bankBal,
    'userid': userId,
    'cardholderid': cardHolderId,
    'status': status,
    
  };
}