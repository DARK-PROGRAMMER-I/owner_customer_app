class Ledger {
  String? ledgerId;
  String? customerId;
  String? ownerId;
  int? creationDateInEpoc;
  String? creationDate;
  bool? hasPayments;
  int? lastUpdateDateInEpoc;
  int? lastPayAmount;
  String? lastPayType;
  double? balance;

  Ledger({
    this.ledgerId,
    this.customerId,
    this.ownerId,
    this.creationDateInEpoc,
    this.creationDate,
    this.hasPayments,
    this.lastUpdateDateInEpoc,
    this.lastPayAmount,
    this.lastPayType,
    this.balance,
  });

  Ledger.fromJson(Map<String, dynamic> json) {
    ledgerId = json['ledgerId'];
    customerId = json['customerId'];
    ownerId = json['ownerId'];
    creationDateInEpoc = json['creationDateInEpoc'];
    creationDate = json['creationDate'];
    hasPayments = json['hasPayments'] ?? false;
    lastUpdateDateInEpoc = json['lastUpdateDateInEpoc'];
    lastPayAmount = json['lastPayAmount'];
    lastPayType = json['lastPayType'];
    balance = (json['balance'] is double) ? json['balance'] : json['balance'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ledgerId'] = ledgerId;
    data['customerId'] = customerId;
    data['ownerId'] = ownerId;
    data['creationDate'] = creationDate;
    data['creationDateInEpoc'] = creationDateInEpoc;
    data['hasPayments'] = hasPayments;
    data['lastUpdateDateInEpoc'] = lastUpdateDateInEpoc;
    data['lastPayType'] = lastPayType;
    data['lastPayAmount'] = lastPayAmount;
    data['balance'] = balance;
    return data;
  }
}
