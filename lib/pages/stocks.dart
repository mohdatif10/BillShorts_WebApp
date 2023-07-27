import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CryptoInfo {
  final String documentId;
  final String symbol;
  final double price;

  CryptoInfo({
    required this.documentId,
    required this.symbol,
    required this.price,
  });

  factory CryptoInfo.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CryptoInfo(
      documentId: doc.id,
      symbol: data['from_currency'] ?? '',
      price: (data['exchange_rate'] ?? 0.0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'CryptoInfo('
        'documentId: $documentId, '
        'symbol: $symbol, '
        'price: $price, ';
  }
}




class StockInfo {
  final String documentId;
  final String symbol;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;

  StockInfo({
    required this.documentId,
    required this.symbol,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  factory StockInfo.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StockInfo(
      documentId: doc.id,
      symbol: data['symbol'] ?? '',
      open: (data['open'] ?? 0.0).toDouble(),
      high: (data['high'] ?? 0.0).toDouble(),
      low: (data['low'] ?? 0.0).toDouble(),
      close: (data['close'] ?? 0.0).toDouble(),
      volume: data['volume'] ?? 0,
    );
  }
    @override
    String toString() {
      return 'StockInfo('
          'documentId: $documentId, '
          'symbol: $symbol, '
          'open: $open, '
          'high: $high, '
          'low: $low, '
          'close: $close, '
          'volume: $volume)';


  }
}

class StockListScreen extends StatefulWidget {
  @override
  _StockListScreenState createState() => _StockListScreenState();

  Future<List<StockInfo>> getStockData() async {
    // Initialize Firebase
    //await Firebase.initializeApp();

    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('stockData').get();
    List<StockInfo> stockInfoList = snapshot.docs
        .map((doc) => StockInfo.fromSnapshot(doc))
        .toList();

    //Convert the document IDs to integers and sort in descending order
    List<int> sortedDocumentIds = stockInfoList
        .map((stockInfo) => int.tryParse(stockInfo.documentId) ?? 0)
        .toList();
    sortedDocumentIds.sort((a, b) => b.compareTo(a));

    // Pick only the last ten document IDs
    List<int> lastTenDocumentIds = sortedDocumentIds.take(10).toList();

    // Filter the stockInfoList to include only the last ten documents
    stockInfoList = stockInfoList
        .where(
            (stockInfo) => lastTenDocumentIds.contains(int.tryParse(stockInfo.documentId) ?? 0))
        .toList();

    return stockInfoList;
  }


  Future<List<CryptoInfo>> getCryptoData() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('cryptoData').get();
    List<CryptoInfo> cryptoInfoList = snapshot.docs
        .map((doc) => CryptoInfo.fromSnapshot(doc))
        .toList();

    // Convert the document IDs to integers and sort in descending order
    List<int> sortedDocumentIds = cryptoInfoList
        .map((cryptoInfo) => int.tryParse(cryptoInfo.documentId) ?? 0)
        .toList();
    sortedDocumentIds.sort((a, b) => b.compareTo(a)); // Sort in descending order

    // Pick only the last 6 document IDs
    List<String> lastSixDocumentIds = sortedDocumentIds.take(6).map((id) => id.toString()).toList();

    // Filter the cryptoInfoList to include only the last six documents
    cryptoInfoList = cryptoInfoList
        .where((cryptoInfo) => lastSixDocumentIds.contains(cryptoInfo.documentId))
        .toList();

    return cryptoInfoList;
  }


}




class _StockListScreenState extends State<StockListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([widget.getStockData(), widget.getCryptoData()]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<StockInfo> stockInfoList = snapshot.data![0];
          List<CryptoInfo> cryptoInfoList = snapshot.data![1];

          // Display both stock and crypto data in the ListView
          List<dynamic> combinedData = [];
          combinedData.addAll(stockInfoList);
          combinedData.addAll(cryptoInfoList);

          // Sort the combined data by documentId if needed

          return ListView.builder(
            itemCount: combinedData.length,
            itemBuilder: (context, index) {
              if (combinedData[index] is StockInfo) {
                StockInfo stockInfo = combinedData[index];
                return ListTile(
                  title: Text(stockInfo.symbol),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Open: ${stockInfo.open}'),
                      Text('High: ${stockInfo.high}'),
                      Text('Low: ${stockInfo.low}'),
                      Text('Close: ${stockInfo.close}'),
                      Text('Volume: ${stockInfo.volume}'),
                    ],
                  ),
                );
              } else if (combinedData[index] is CryptoInfo) {
                CryptoInfo cryptoInfo = combinedData[index];
                return ListTile(
                  title: Text(cryptoInfo.symbol),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: ${cryptoInfo.price}'),
                    ],
                  ),
                );
              } else {
                return SizedBox(); // Placeholder widget if needed
              }
            },
          );
        },
      ),
    );
  }
}
