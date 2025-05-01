enum TransactionType {
  income,
  expense,
}

extension TransactionTypeExt on TransactionType {
  String get shortName => toString().split('.').last;
}