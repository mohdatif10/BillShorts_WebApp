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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isSmallSize= screenWidth < 800; // Check if screen width is less than 800px

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFf9f7f4),
        automaticallyImplyLeading: false,
        actions: isSmallSize
            ? [
          // Add the IconButton for the menu drop icon
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: Color(0xFF639843), // Set the background color of the dropdown menu
            elevation: 2, // Set the elevation of the dropdown menu
            onSelected: (value) {
              // Handle the menu item selection here
              switch (value) {
                case 'home':
                  Navigator.pushNamed(context, '/home');
                  break;
                case 'justTitles':
                  Navigator.pushNamed(context, '/justTitles');
                  break;
                case 'stocks':
                  Navigator.pushNamed(context, '/stocks');
                  break;
                case 'literature':
                  Navigator.pushNamed(context, '/literature');
                  break;
                case 'about':
                  Navigator.pushNamed(context, '/about');
                  break;
              }
            },
            icon: Icon(
              Icons.menu,
              size: 30, // Set the size of the icon to 30
              color: Colors.black, // Set the color of the icon to black
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'home',
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white, // Customize the text color to white
                    fontFamily: 'Crimson', // Use the Crimson font
                    fontSize: 18, // Set the font size
                    // Add more style properties as needed (e.g., fontWeight, letterSpacing, etc.)
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'justTitles',
                child: Text(
                  'Just Titles',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Crimson',
                    fontSize: 18,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'stocks',
                child: Text(
                  'Stocks & Crypto',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Crimson',
                    fontSize: 18,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'literature',
                child: Text(
                  'Literature',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Crimson',
                    fontSize: 18,
                  ),
                ),
              ),
              PopupMenuItem<String>(
                value: 'about',
                child: Text(
                  'About',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Crimson',
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ]
            : [],
        title: GestureDetector(
          onTap: () {
            // Navigate back to the home page when 'Bill \$horts' is clicked
            Navigator.pushNamed(context, '/home');
          },
          child: Align(
            alignment: isSmallSize? Alignment(-1, -1):Alignment(-0.9, -0.5),
            child: Text(
              'Bill \$horts',
              style: TextStyle(
                fontFamily: 'Crimson',
                color: Color(0xFF639843),
                fontSize: isSmallSize ? screenWidth * 0.08 : screenWidth * 0.030,
              ),
            ),
          ),
        ),
        centerTitle: false,
        elevation: 1.1,
        toolbarHeight: screenHeight * 0.08,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: isSmallSize ? false : true,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, screenHeight * 0.03, 0, screenHeight * 0.01),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(color: Color(0xFFf9f7f4)),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          print('Home button pressed...');
                          Navigator.pushNamed(context, '/home');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFf9f7f4),
                        ),
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontFamily: "Crimson",
                            fontSize: screenWidth * 0.022,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/justTitles');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFf9f7f4),
                        ),
                        child: Text(
                          'Just Titles',
                          style: TextStyle(
                            fontFamily: "Crimson",
                            fontSize: screenWidth * 0.022,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/stocks');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFf9f7f4),
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.018, 0, screenWidth * 0.018, 0),
                        ),
                        child: Text(
                          'Stocks & Crypto',
                          style: TextStyle(
                            fontFamily: "Crimson",
                            fontSize: screenWidth * 0.022,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          print('Literature button pressed ...');
                          Navigator.pushNamed(context, '/literature');

                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFf9f7f4),
                        ),
                        child: Text(
                          'Literature',
                          style: TextStyle(
                            fontFamily: "Crimson",
                            fontSize: screenWidth * 0.022,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/about');
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Color(0xFFf9f7f4),
                        ),
                        child: Text(
                          'About',
                          style: TextStyle(
                            fontFamily: "Crimson",
                            fontSize: screenWidth * 0.022,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(color: Color(0xFFEFF1FD)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: Future.wait([widget.getStockData(), widget.getCryptoData()]),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<StockInfo> stockInfoList = snapshot.data![0];
                  List<CryptoInfo> cryptoInfoList = snapshot.data![1];

                  List<dynamic> combinedData = [];
                  combinedData.addAll(stockInfoList);
                  combinedData.addAll(cryptoInfoList);

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Adjust the crossAxisCount as needed
                      childAspectRatio: screenWidth / (screenHeight * 0.50), // Adjust the aspect ratio
                    ),
                    itemCount: combinedData.length,
                    itemBuilder: (context, index) {
                      dynamic data = combinedData[index];
                      return Card(
                        elevation: 2,
                        color: (data is StockInfo && data.close > data.open)
                            ? Colors.green
                            : (data is CryptoInfo)
                            ? Colors.yellow
                            : Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data is StockInfo ? data.symbol : data is CryptoInfo ? data.symbol : '',
                                style: TextStyle(fontWeight: FontWeight.bold,
                                fontSize:isSmallSize? 20:28),
                              ),
                              SizedBox(height: 4),
                              if (data is StockInfo)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Open: ${data.open}',
                                        style: TextStyle(fontSize: isSmallSize ? 16 : 18)),
                                    Text('High: ${data.high}',
                                        style: TextStyle(fontSize: isSmallSize ? 16 : 18)),
                                    Row(
                                      children: [
                                        Text('Low: ${data.low}',
                                            style: TextStyle(fontSize: isSmallSize ? 16 : 18)),
                                        Spacer(), // Adds space to push the icon to the right
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            data is StockInfo ? Icons.auto_graph : Icons.contrast,
                                            color: Colors.black,
                                            size: 24.0,
                                          ),
                                        ),
                                      ],
                                    ),

                                    Text('Close: ${data.close}',
                                        style: TextStyle(fontSize: isSmallSize ? 16 : 18)),
                                    Text('Volume: ${data.volume}',
                                        style: TextStyle(fontSize: isSmallSize ? 16 : 18)),
                                  ],
                                ),
                              if (data is CryptoInfo)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Exchange Price: \$${data.price.toStringAsFixed(2)}',
                                   style: TextStyle(
                                     fontSize:isSmallSize? 15:25)),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Icon(
                                        data is StockInfo ? Icons.auto_graph: Icons.contrast,
                                        color: Colors.black,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

    );
  }

}