class TransactionModel_inandiar {
  final String trxId_inandiar;
  final num total_inandiar;
  final String status_inandiar;
  final List<Map<String, dynamic>> items_inandiar;

  TransactionModel_inandiar({
    required this.trxId_inandiar,
    required this.total_inandiar,
    required this.status_inandiar,
    required this.items_inandiar,
  });

  Map<String, dynamic> toJson_inandiar() {
    return {
      "trx_id": trxId_inandiar,
      "total": total_inandiar,
      "status": status_inandiar,
      "items": items_inandiar,
    };
  }
}