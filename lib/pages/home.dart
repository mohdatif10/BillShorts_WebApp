import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';
//import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'stocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  bool _isButtonVisible = true;
  late String articleTitle = '';
  late String articlePrecis = '';
  late String articleImage = '';
  int currentArticleNumber = 0;
  late String article_number = 'null';
  bool _isDateVisible = true;
  bool allowPageChange = true;
  final videoURL = " ";
  bool _isContainerOpen = true;


  //late YoutubePlayerController _controller;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String formatDate(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    final formatter = DateFormat('dd MMMM, yyyy');
    return formatter.format(parsedDate);
  }

  void _shareShareWebsiteUrl(String content) {
    String sharingText = "Check out BillShorts.com for shorts in the financial realm\n\n";
    Share.share(
        sharingText + content); // Concatenate the sharing text and content
  }

  final CarouselController buttonCarouselController = CarouselController();


  Future<void> fetchArticles() async {
    try {
      var firestore = FirebaseFirestore.instance;
      var collectionReference = firestore.collection('archive');

      var snapshot = await collectionReference
          .orderBy('article_number', descending: true)
          .limit(100) // Limit the number of documents to 10
          .get();

      if (snapshot.docs.isNotEmpty) {
        print("NOT EMPTY");
        var fetchedArticles = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;

          // Ensure that the values are of type String
          String id = doc.id;
          String title = data['title'] as String? ?? '';
          String content = data['content'] as String? ?? '';
          String image = data['image_url'] as String? ?? '';
          String dest_link = data['dest_link'] as String? ?? '';

          // Handling nullable values and converting to String
          String date_time = data['date_time'] == null ? '' : data['date_time']
              .toString();
          String article_number = data['article_number'] == null
              ? '0'
              : data['article_number'].toString();

          return {
            'id': id,
            'title': title,
            'content': content,
            'image': image,
            'dest_link': dest_link,
            'date_time': date_time,
            'article_number': article_number,
          };
        }).toList();

        // Convert "article_number" to an actual numeric value before sorting
        fetchedArticles.sort((a, b) {
          int articleNumberA = int.parse(a['article_number'] ?? '0');
          int articleNumberB = int.parse(b['article_number'] ?? '0');
          return articleNumberA.compareTo(articleNumberB);
        });

        setState(() {
          articles = List<Map<String, String>>.from(fetchedArticles.reversed);
          jsonDumpLength = articles.length;
        });
      } else {
        print("No Docs received in fetchArticles()");
      }
    } catch (error) {
      print('Request error: $error');
    }
    print("articles $articles");
    print("jsonDumpLength $jsonDumpLength");
  }

  void toggleContainer() {
    setState(() {
      _isContainerOpen = !_isContainerOpen;
    });
  }


  void _toggleButtonVisibility() {
    setState(() {
      _isButtonVisible = !_isButtonVisible;
      _isDateVisible = _isButtonVisible;

      if (_isButtonVisible) {
        _fadeController.forward();
      } else {
        _fadeController.reverse();
      }
    });
  }

  Map<String, String> getLatestArticleTitlesAndLinks() {
    Map<String, String> latestArticlesMap = {};

    // Iterate through the articles list and get the latest 25 titles and dest_links
    for (int i = 0; i < articles.length && i < 25; i++) {
      String title = articles[i]['title']??'';
      String destLink = articles[i]['dest_link']??'';
      latestArticlesMap[title] = destLink;
    }

    return latestArticlesMap;
  }


  List<StockInfo> stockInfoList = [
  ]; // List to store the retrieved stock information
  List<CryptoInfo> cryptoInfoList = [
  ]; // List to store the retrieved stock information


  // Method to fetch stock information
  Future<void> fetchStockData() async {
    try {
      StockListScreen stockListScreen = StockListScreen();
      List<StockInfo> data = await stockListScreen.getStockData();
      setState(() {
        stockInfoList = data;
      });
    } catch (error) {
      // Handle error if any
      print('Error fetching stock data: $error');
    }

    print("stockInfoList $stockInfoList");
  }

  // Method to fetch crypto information
  Future<void> fetchCryptoData() async {
    try {
      StockListScreen stockListScreen = StockListScreen();
      List<CryptoInfo> data = await stockListScreen.getCryptoData();
      setState(() {
        cryptoInfoList = data;
      });
    } catch (error) {
      // Handle error if any
      print('Error fetching crypto data: $error');
    }

    print("cryptoInfoList: $cryptoInfoList");
  }


  @override
  void initState() {
    fetchArticles();
    fetchStockData(); // Call the method to fetch stock information
    fetchCryptoData();

    //final currentArticle = articles[currentIndex];

    // _controller = YoutubePlayerController(
    //   initialVideoId: YoutubePlayer.convertUrlToId(currentArticle[dest_link] ?? '') ?? '',
    //   flags: YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: true,
    //   ),
    // );


    _fadeController = AnimationController(
      vsync: this,
      duration: Duration(
          milliseconds: 500), // Set the duration as per your preference
    );

    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);

    super.initState();
  }


  List<Map<String, String>> articles = [];
  int currentIndex = 0; // Declare and initialize currentIndex here
  final carouselTitlesController = PageController(viewportFraction: 0.2);
  int jsonDumpLength = 0; // Variable to store the length of the JSON dump

  void scrollToTopArticle() {
    buttonCarouselController.jumpToPage(0);
    setState(() {
      currentIndex = 0;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    final bool isLaptopSize = screenWidth > 700;
    final bool isPhoneSize = screenWidth < 400;
    final bool isComputerSize = screenWidth > 1000;

    return Scaffold(
      body: GestureDetector(
        onTap: _toggleButtonVisibility,
        child: Stack(
          children: [
            Row(
              children: [
                if (isLaptopSize)
                  Expanded(
                    flex: 1,
                    child: Visibility(
                      visible: _isContainerOpen,
                      child: Container(
                        color: Color(0xFF639843),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              color: Color(0xFF639843),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0.0),
                                child: Center(
                                  child: Text(
                                    'Trending Stocks',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isComputerSize
                                          ? 30
                                          : (isLaptopSize ? 24 : 24),
                                      fontFamily: "Borel",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Scrollbar(
                                child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  itemCount: stockInfoList.length,
                                  itemBuilder: (context, index) {
                                    StockInfo stock = stockInfoList[index];
                                    return GestureDetector(
                                      onTap: () {
                                        // Show the popup dialog on tap
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  '${stock.symbol} Stock Info',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28)),
                                              content: Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'High: ${stock.high
                                                        .toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ), // Set text color to white
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    'Low: ${stock.low
                                                        .toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ), // Set text color to white// Set text color to white
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    'Close: ${stock.close
                                                        .toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ), // Set text color to white
                                                  ),
                                                  SizedBox(height: 6),
                                                  Text(
                                                    'Volume: ${stock.volume}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                    ), // Set text color to white
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Close'),
                                                ),
                                              ],
                                              backgroundColor: Colors
                                                  .grey[800], // Set the background color here
                                            );
                                          },
                                        );
                                      },
                                      child: Tooltip(
                                        message: 'High: ${stock.high
                                            .toStringAsFixed(2)}\nLow: ${stock
                                            .low.toStringAsFixed(
                                            2)}\nClose: ${stock.close
                                            .toStringAsFixed(
                                            2)}\nVolume: ${stock.volume}',
                                        textStyle: TextStyle(
                                            color: Colors.white),
                                        // Set the text color of the tooltip
                                        decoration: BoxDecoration(
                                          color: Colors.grey[800],
                                          // Set the background color of the tooltip
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Set the border radius of the tooltip
                                        ),
                                        padding: EdgeInsets.all(8.0),
                                        // Set the padding of the tooltip
                                        preferBelow: true,
                                        // Display the tooltip below the widget
                                        verticalOffset: 10,
                                        // Set the vertical offset of the tooltip
                                        waitDuration: Duration(
                                            milliseconds: 400),
                                        // Set the wait duration before showing the tooltip
                                        child: Container(
                                            color: Color(0xFF2D3032),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 2.0),
                                            // Adjust the padding of the ListTile
                                            child: ListTile(
                                              title: Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text(
                                                    stock.symbol,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: isComputerSize
                                                          ? 22
                                                          : 18,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    '${stock.close
                                                        .toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      fontSize: isComputerSize
                                                          ? 22
                                                          : 18,
                                                      color: stock.close > stock
                                                          .open
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 0.0),
                              child: Center(
                                child: Text(
                                  'Trending Crypto',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isComputerSize
                                        ? 30
                                        : (isLaptopSize ? 24 : 24),
                                    fontFamily: "Borel",
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 1,
                              // Crypto list takes up 1/3 of the space of the stocks list
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: cryptoInfoList.length,
                                itemBuilder: (context, index) {
                                  CryptoInfo crypto = cryptoInfoList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Show the popup dialog on tap
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                '${crypto.symbol} Crypto Info',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 28)),
                                            content: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Exchange Rate: ${crypto.price
                                                      .toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                  ), // Set text color to white
                                                ),
                                                SizedBox(height: 6),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Close'),
                                              ),
                                            ],
                                            backgroundColor: Colors
                                                .grey[800], // Set the background color here
                                          );
                                        },
                                      );
                                    },
                                    child: Tooltip(
                                      message: 'Exchange Rate: ${crypto.price
                                          .toStringAsFixed(2)}',
                                      textStyle: TextStyle(color: Colors.white),
                                      // Set the text color of the tooltip
                                      decoration: BoxDecoration(
                                        color: Colors.grey[800],
                                        // Set the background color of the tooltip
                                        borderRadius: BorderRadius.circular(
                                            10.0), // Set the border radius of the tooltip
                                      ),
                                      padding: EdgeInsets.all(8.0),
                                      // Set the padding of the tooltip
                                      preferBelow: true,
                                      // Display the tooltip below the widget
                                      verticalOffset: 10,
                                      // Set the vertical offset of the tooltip
                                      waitDuration: Duration(milliseconds: 400),
                                      // Set the wait duration before showing the tooltip
                                      child: Container(
                                        color: Color(0xFF2D3032),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 3.0),
                                          // Adjust the padding of the ListTile
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  crypto.symbol,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: isComputerSize
                                                        ? 22
                                                        : 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${crypto.price
                                                      .toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: isComputerSize
                                                        ? 22
                                                        : 18,
                                                    color: Color(0xFF0563C1),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),

                Expanded(
                  flex: isLaptopSize ? 3 : 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: CarouselSlider.builder(
                          options: CarouselOptions(
                            scrollPhysics: RangeMaintainingScrollPhysics(),
                            enableInfiniteScroll: false,
                            scrollDirection: Axis.vertical,
                            autoPlay: false,
                            enlargeCenterPage: true,
                            aspectRatio: 2.5,
                            viewportFraction: 1.0,
                            // Take up the whole screen vertically
                            initialPage: currentIndex,
                            // Maintain the current index
                            onPageChanged: (index,
                                CarouselPageChangedReason reason) {
                              setState(() {
                                if (reason ==
                                    CarouselPageChangedReason.manual) {
                                  currentArticleNumber = int.parse(
                                      articles[index]['article_number'] ?? '0');
                                  print(
                                      'Current Article Number: $currentArticleNumber');

                                  if (currentArticleNumber == jsonDumpLength) {
                                    return; // Return early, don't change the currentIndex
                                  }
                                }
                                currentIndex = index;
                              });
                            },
                          ),
                          carouselController: buttonCarouselController,
                          itemCount: articles.length,
                          itemBuilder: (BuildContext context, int index,
                              int realIndex) {
                            var article = articles[index];

                            // Widget mediaWidget = article['dest_link']?.contains('youtube.com') == true
                            //     ? YoutubePlayer(
                            //   controller: _controller,
                            //   showVideoProgressIndicator: true,
                            //   progressIndicatorColor: Colors.red,
                            //   onReady: () {
                            //     print('Player is ready');
                            //   },
                            // )
                            Widget mediaWidget = Image.network(
                              article['image'] ?? '',
                              // The article['image'] should be the URL of the image
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child,
                                  loadingProgress) {
                                // This function is called while the image is loading
                                if (loadingProgress == null) return child;

                                // You can return a placeholder widget here, like CircularProgressIndicator
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                        null
                                        ? loadingProgress
                                        .cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // This function is called when there is an error loading the image from the URL
                                // You can return a fallback image here, in this case, 'assets/logo.png'
                                return Image.asset(
                                  'assets/logo.png',
                                  fit: BoxFit.cover,
                                );
                              },
                            );

                            return Container(
                              color: Colors.black,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        if (articles.isNotEmpty) {
                                          launchUrl(Uri.parse(
                                              articles[currentIndex]['dest_link'] ??
                                                  ''));
                                        }
                                      },
                                      child: Container(
                                        color: Color(0xFF639843),
                                        child: mediaWidget,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: Colors.grey[200],
                                      padding: EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              launchUrl(Uri.parse(
                                                  article['dest_link'] ?? ''));
                                            },
                                            child: Text(
                                              article['title'] ?? '',
                                              style: TextStyle(
                                                fontSize: isComputerSize
                                                    ? 36.0
                                                    : (isPhoneSize ? 20 : 24),
                                                color: Color(0xFF0563C1),
                                                fontFamily: "NoticiaText-Regular.ttf",
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8.0),
                                          Expanded(
                                            child: SingleChildScrollView(
                                              child: Text(
                                                article['content'] ?? '',
                                                style: TextStyle(
                                                  height: 1.5,
                                                  fontSize: isComputerSize
                                                      ? 24.0
                                                      : (isPhoneSize ? 14 : 16),
                                                  // Conditional font size
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: _isDateVisible,
                                            child: FadeTransition(
                                              opacity: _fadeAnimation,
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Click article title for more / ${formatDate(
                                                        article['date_time'] ??
                                                            '')}',
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  IconButton(
                                                    onPressed: () {
                                                      String content = article['content'] ??
                                                          ''; // Get the article content or an empty string if it's null
                                                      _shareShareWebsiteUrl(
                                                          content); // Call the function with the article content
                                                    },
                                                    icon: Icon(Icons.share),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (isLaptopSize)
                        ElevatedButton(
                          onPressed: () {
                            toggleContainer();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF639843),
                            // You can also specify other styles if needed, such as padding, shape, etc.
                          ),
                          child: Text(
                            _isContainerOpen ? 'Close Stocks' : 'Open Stocks',
                            style: TextStyle(
                              color: Colors
                                  .white,
                              fontSize: 16,// Set text color to white to make it visible on the black background
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          final destLink = (currentIndex == articles.length - 1)
                              ? articles[0]['dest_link']
                              : articles[(currentIndex + 1) %
                              articles.length]['dest_link'];
                          launchUrl(Uri.parse(destLink ?? ''));
                        },
                        child: Container(
                          color: Color(0xFF2D3032),
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            articles[(currentIndex + 1) %
                                articles.length]['title'] ?? '',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: Visibility(
                visible: _isButtonVisible,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: FloatingActionButton(
                    onPressed: () {
                      buttonCarouselController.jumpToPage(0);
                      fetchArticles();
                    },
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                      ),
                    ),
                    child: Container(
                      width: 45.24,
                      height: 55.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        color: Colors.black,
                      ),
                      child: Icon(
                        Icons.arrow_upward,
                        color: Color(0xFF639843),
                        size: 40.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isLaptopSize)
              Visibility(
                visible: !_isContainerOpen,
                child: Container(
                  width: screenWidth / 4,
                  height: screenHeight,
                  color: Color(0xFF639843),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Center(
                          child: Text(
                            "Latest Hot Headlines",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isComputerSize ? 30 : (isLaptopSize ? 24 : 24),
                              fontFamily: "Borel",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: carouselTitlesController,
                          itemCount: getLatestArticleTitlesAndLinks().length,
                          itemBuilder: (context, index) {
                            var latestArticlesMap = getLatestArticleTitlesAndLinks();
                            var titles = latestArticlesMap.keys.toList();
                            var title = titles[index];
                            var destLink = latestArticlesMap[title];
                            var truncatedLink = (destLink ?? '').substring(0, 30);
                            return GestureDetector(
                              onTap: () {
                                launchUrl(Uri.parse(destLink ?? ''));
                              },
                              child: Tooltip(
                                message: truncatedLink ?? '',
                                child: Container(
                                  color: Color(0xFF2D3032),
                                  padding: EdgeInsets.fromLTRB(8, 14, 8, 14),
                                  child: Text(
                                    title,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),


          ],
        ),
      ),
    );
  }
}