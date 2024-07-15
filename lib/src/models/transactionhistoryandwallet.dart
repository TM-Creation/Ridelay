class DriverWallet {
  final String id;
  final String owner;
  final String ownerModel;
  final double balance;
  final List<Transaction> transactions;
  final String createdAt;
  final String updatedAt;
  final int v;

  DriverWallet({
    required this.id,
    required this.owner,
    required this.ownerModel,
    required this.balance,
    required this.transactions,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory DriverWallet.fromJson(Map<String, dynamic> json) {
    return DriverWallet(
      id: json['_id'] ?? '',
      owner: json['owner'] ?? '',
      ownerModel: json['ownerModel'] ?? '',
      balance: json['balance'] ?? 0,
      transactions: (json['transactions'] as List<dynamic>?)
          ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
          .toList() ??
          [],
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}

class Transaction {
  final double amount;
  final String type;
  final String date;
  final String description;
  final String id;

  Transaction({
    required this.amount,
    required this.type,
    required this.date,
    required this.description,
    required this.id,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      amount: json['amount'] ?? 0.0,
      type: json['type'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      id: json['_id'] ?? '',
    );
  }
}