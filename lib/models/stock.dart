import 'package:canalendar/enumerations/stock_type.dart';

class Stock implements Comparable<Stock> {
  StockType type;
  double amount;
  double price;
  DateTime purchaseDate;
  DateTime? finishDate;

  Stock(this.type, this.amount, this.price, this.purchaseDate, {this.finishDate});

  bool setFinishDate(DateTime finish) {
    if (finish.isAfter(purchaseDate)) return false;
    finishDate = finish;
    return true;
  }

  Map<String, dynamic> toJson() {
    if (finishDate == null) {
      return {
        'type': type.index,
        'amount': amount,
        'price': price,
        'purchaseDate': purchaseDate.toIso8601String()
      };
    }
    else {
      return {
        'type': type.index,
        'amount': amount,
        'price': price,
        'purchaseDate': purchaseDate.toIso8601String(),
        'finishDate': finishDate!.toIso8601String(),
      };
    }
  }

  factory Stock.fromJson(Map<String, dynamic> json) {
    dynamic finishDate = json['finishDate'];
    return Stock(
      StockType.values[json['type']],
      json['amount'],
      json['price'],
      DateTime.parse(json['purchaseDate']),
      finishDate: finishDate != null ? DateTime.parse(json['finishDate']) : null,
    );
  }

  @override
  int compareTo(Stock other) {
    return purchaseDate.compareTo(other.purchaseDate);
  }
}