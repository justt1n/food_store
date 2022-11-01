part of 'services.dart';

class TransactionServices {
  // Ambil Data Transaksi

  static Future<ApiReturnValue<List<Transaction>>> getTransactions(
      {http.Client? client}) async {
    if (client == null) {
      client = http.Client();
    }
    var url = Uri.parse(
        'http://foodmarket-backend.buildwithangga.id/api/transaction/?limit=1000');

    var response = await client.get(url, headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${User.token}"
    });

    if (response.statusCode != 200) {
      return ApiReturnValue(message: 'Please Try Again');
    }
    var data = jsonDecode(response.body);

    List<Transaction> transactions = (data['data']['data'] as Iterable)
        .map((e) => Transaction.fromJson(e))
        .toList();

    return ApiReturnValue(value: transactions);
  }

// Proses Transaksi
  static Future<ApiReturnValue<Transaction>> submitTransaction(
      Transaction transaction,
      {http.Client? client}) async {
    if (client == null) {
      client = http.Client();
    }
    var url =
        Uri.parse('http://foodmarket-backend.buildwithangga.id/api/checkout');
    var response = await client.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${User.token}"
        },
        body: jsonEncode(<String, dynamic>{
          'food_id': transaction.food!.id,
          'user_id': transaction.user!.id,
          'quantity': transaction.quantity,
          'total': transaction.total,
          'status': "PENDING"
        }));

    if (response.statusCode != 200) {
      return ApiReturnValue(message: "Please Try Again");
    }

    var data = jsonDecode(response.body);

    Transaction value = Transaction.fromJson(data['data']);

    return ApiReturnValue(value: value);
  }
}
