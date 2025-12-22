
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/app_barrel.dart';

// class TransactionItem {
//   String toName,toBank,toAcct,ref;
//   double amt;
//   DateTime dt;
//   bool isDebit,status;

//   String get dateTime => DateFormat("MMM dd yyyy | hh:mm").format(dt);
//   String get amtString => amt.toString();
//   String get title => "${isDebit ? "Receive from " : "Transfer to"} $toName";
//   String get desc => DateFormat("MMM dd yyyy hh:mmaa").format(dt);
//   String get tdesc => DateFormat("hh:mm aa").format(dt);

//   TransactionItem({
//     this.amt=0,
//     required this.dt,
//     this.isDebit = true,
//     this.status = true,
//     this.toName="",
//     this.toBank="",
//     this.toAcct="",
//     this.ref="",
//   });
// }

enum TransactionType {
  funding("Funding"),
  transfer("Transfer"),
  cardPayment("Card Payment"),
  cardFunding("Card Funding"),
  cardWithdrawal("Card Withdrawal");

  final String title;

  const TransactionType(this.title);
}

enum TransactionStatus {
  success("Successful","success", AppColors.green,AppColors.primaryColor),
  failed("Failed","failed", AppColors.red,AppColors.red),
  processing("Processing","processing", Colors.amber,AppColors.accentColor);

  final String title;
  final String desc;
  final Color color,color2;

  const TransactionStatus(this.title, this.desc,this.color,this.color2);
}

class Bank {
  final String name,code;
  Bank(this.name,this.code);

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      json["name"],json['code']
    );}
}

class Transaction {
  int id;
  String? txRef;
  double? txAmount;
  String? txDestination;
  String? txAcctNo;
  String? txAcctBank;
  String? txAcctBankCode;
  String? txAcctName;
  String? txDescription;
  TransactionType? txType;
  TransactionStatus status;
  int? walletId;
  int? cardId;
  DateTime? updatedAt;
  DateTime? createdAt;

  String get dateTime => DateFormat("MMM dd yyyy | hh:mm").format(createdAt!);
  String get amtString => txAmount.toString();
  String get title => txType!.title;
  String get desc => DateFormat("MMM dd yyyy hh:mmaa").format(createdAt!);
  String get tdesc => DateFormat("hh:mm aa").format(createdAt!);
  bool get isDebit =>
      [TransactionType.transfer, TransactionType.cardFunding].contains(txType);

  Transaction({
    this.id = 0,
    this.txRef,
    this.txAmount,
    this.txDestination,
    this.txAcctNo,
    this.txAcctBank,
    this.txAcctBankCode,
    this.txAcctName,
    this.txDescription,
    this.txType,
    this.status = TransactionStatus.processing,
    this.walletId,
    this.cardId,
    this.updatedAt,
    this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      txRef: json['txref'],
      txAmount: json['txamount']?.toDouble(),
      txDestination: json['txdestination'],
      txAcctNo: json['txacctno'],
      txAcctBank: json['txacctbank'],
      txAcctBankCode: json['txacctbankcode'],
      txAcctName: json['txacctname'],
      txDescription: json['txdescription'],
      txType: json['txtype'] != null
          ? TransactionType.values.firstWhere(
              (e) =>
                  e.toString().split('.').last ==
                  json['txtype'].replaceAll('-', ''),
              orElse: () => TransactionType.funding)
          : null,
      status: TransactionStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => TransactionStatus.processing),
      walletId: json['walletid'],
      cardId: json['cardid'],
      updatedAt:
          json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: DateTime.parse(json['createdat']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'txref': txRef,
        'txamount': txAmount,
        'txdestination': txDestination,
        'txacctno': txAcctNo,
        'txacctbank': txAcctBank,
        'txacctbankcode': txAcctBankCode,
        'txacctname': txAcctName,
        'txdescription': txDescription,
        'txtype': txType
            ?.toString()
            .split('.')
            .last
            .replaceAllMapped(RegExp(r'[A-Z]'),
                (match) => '-${match.group(0)?.toLowerCase()}')
            .replaceFirst('-', ''),
        'status': status.toString().split('.').last,
        'walletid': walletId,
        'cardid': cardId,
      };
}



class Esim {
  String orderId, country;
  String? msisdn;
  int days;
  String status;
  DateTime? updatedAt;
  DateTime? createdAt;
  DateTime? startDate;
  DateTime? endDate;

  Esim({
    required this.orderId,
    required this.country,
    this.msisdn,
    required this.days,
    required this.status,
    this.updatedAt,
    this.createdAt,
    this.startDate,
    this.endDate,
  });

  int get expiryDays {
    if (startDate == null || endDate == null) return -1;
    return endDate!.difference(DateTime.now()).inDays;
  }


  factory Esim.fromJson(Map<String, dynamic> json) {
    return Esim(
      orderId: json['orderid'],
      country: json['country'],
      msisdn: json['msisdn'],
      days: json['noofdays'],
      status: json['status'],
      updatedAt: json['updatedat'] != null ? DateTime.parse(json['updatedat']) : null,
      createdAt: json['createdat'] != null ? DateTime.parse(json['createdat']) : null,
      startDate: json['startdate'] != null ? DateTime.parse(json['startdate']) : null,
      endDate: json['enddate'] != null ? DateTime.parse(json['enddate']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'orderid': orderId,
    'country': country,
    'msisdn': msisdn,
    'days': days,
    'status': status,
    'updatedat': updatedAt?.toIso8601String(),
    'createdat': createdAt?.toIso8601String(),
    'startdate': startDate?.toIso8601String(),
    'enddate': endDate?.toIso8601String(),
  };
}
