  import 'package:flutter/material.dart';
  import 'package:intl/intl.dart';
  import 'package:carousel_slider/carousel_slider.dart';
  import 'package:url_launcher/url_launcher.dart';
  import 'package:flutter/services.dart';
  import 'package:billshorts_webapp/pages/justtitles.dart';
  import 'package:billshorts_webapp/pages/article_manager.dart';


  // Define a private class to hold the page controller
  class _PageModel {
    PageController? pageViewController;
  }
  
  // Define the Home widget
  class Home extends StatefulWidget {
    const Home({Key? key}) : super(key: key);
  
    @override
    _HomeState createState() => _HomeState();
  }
  
  // Define the state class for the Home widget
  class _HomeState extends State<Home> with TickerProviderStateMixin {
    // Declare variables and controllers
    late PageController pageViewController;
    late String articleTitle = '';
    late String articlePrecis = '';
    late String articleImage = '';
    int currentArticleNumber = 0;
    late String article_number = 'null';
    bool allowPageChange = true;
    final videoURL = " ";
    bool _isContainerOpen = true;
  
    // Define the animation controller and animation
    late AnimationController _fadeController;

    // Define a function to format the date
    String formatDate(String dateTime) {
      final parsedDate = DateTime.parse(dateTime);
      final formatter = DateFormat('dd MMMM, yyyy');
      return formatter.format(parsedDate);
    }
  
    // Declare the carousel controller
    final CarouselController buttonCarouselController = CarouselController();

    void toggleContainer() {
      setState(() {
        _isContainerOpen = !_isContainerOpen;
      });
    }

    late _PageModel _model;
  
    // Declare a GlobalKey for the scaffold
    final scaffoldKey = GlobalKey<ScaffoldState>();
  
    @override
    void initState() {
      pageViewController = PageController(initialPage: 0);
      _model = _PageModel();
      _model.pageViewController = pageViewController;

      WidgetsBinding.instance?.addPostFrameCallback((_) => setState(() {}));

      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await initializeArticles();
        // setState if needed
      });
  
      _fadeController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500), // Set the duration as per your preference
      );

      super.initState();
    }
  
    // Declare the articles list and currentIndex
    List<Map<String, String>> articles = [];
    int currentIndex = 0;
    final carouselTitlesController = PageController(viewportFraction: 0.2);
    int jsonDumpLength = 0; // Variable to store the length of the JSON dump
  
    @override
    void dispose() {
      pageViewController.dispose(); // Dispose the page controller when it is no longer needed.
      _fadeController.dispose();
      super.dispose();
    }

    Future<void> initializeArticles() async {
      ArticleManager articleManager = ArticleManager();
      List<Map<String, String>> fetchedArticles = await articleManager.fetchArticles();
      print("Fetched Articles: $fetchedArticles");

      setState(() {
        articles = fetchedArticles;
        jsonDumpLength = fetchedArticles.length;
      });
    }
  
    @override
    Widget build(BuildContext context) {
      // Get screen dimensions
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      bool isSmallSize= screenWidth < 800; // Check if screen width is less than 800px
  
      return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor:Color(0xFFf9f7f4),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JustTitlesPage(),
                        ),
                      );
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
                  // Add more PopupMenuItem widgets for other menu items
                  // ...
                ],
              ),
            ]
                : [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IconButton(
                    onPressed: () {
                      if (currentIndex > 0) {
                        pageViewController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(Icons.arrow_back_ios,
                      color: Colors.black, // Set the color of the icon to black
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: IconButton(
                    onPressed: () {
                      if (currentIndex < articles.length - 1) {
                        pageViewController.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios,
                      color: Colors.black, // Set the color of the icon to black
                    ),
                  ),
                ),
              ),
            ],
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
            top: true,
            child: Wrap(
              spacing: 0,
              runSpacing: 0,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.start,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.start,
              verticalDirection: VerticalDirection.down,
              clipBehavior: Clip.none,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JustTitlesPage(),
                                ),
                              );
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


                Visibility(
                  visible: !isSmallSize,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                          children:[
                            Expanded(
                              child: Container(
                                height:screenHeight*0.025,
                                width: screenWidth*1,
                                color: Color(0xFFf9f7f4),
                              ),

                            ),
                          ]
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Stack(
                              children: [
                                Container(
                                width: screenWidth * 1.0, // Adjust the width
                                height: screenHeight * 0.8, // Adjust the height
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.04),
                                  child: PageView.builder(
                                    onPageChanged: (index) {
                                      setState(() {
                                        currentIndex = index;
                                        print("currentIndex  $currentIndex");
                                      });
                                    },
                                    controller: _model.pageViewController ??= PageController(initialPage: 0),
                                    scrollDirection: Axis.horizontal,
                                    itemCount: articles.length, // Number of pages = number of articles
                                    itemBuilder: (context, index) {
                                      // Get data for the current article
                                      var articleData = articles[index];

                                      return Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(screenWidth * 0.01),
                                                child: Image.network(
                                                  articleData['image'] ?? 'https://example.com/placeholder.jpg',
                                                  fit: BoxFit.cover,
                                                  height: screenHeight * 2 / 2.5,
                                                ),
                                              ),
                                            ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                    height: screenHeight * 0.22,
                                                    color: Color(0xFFEFF1FD),
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(8, 2, 2, 2),
                                                      child: SingleChildScrollView(
                                                        child: Column(
                                                          // mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
                                                          // crossAxisAlignment: CrossAxisAlignment.center, // Center the text horizontally within the column
                                                           children: [
                                                            Text(
                                                              articleData['title'] ?? "",
                                                              style: TextStyle(
                                                                fontFamily: 'Tienne',
                                                                color: Color(0xFF0563C1),
                                                                fontSize: screenWidth<1400? 28 :30,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                Container(
                                                  height: screenHeight * 0.42,
                                                  color: Color(0xFFEFF1FD),
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 2, 0),
                                                    child: SingleChildScrollView(
                                                      child: LayoutBuilder(
                                                        builder: (context, constraints) {
                                                          double screenWidth = constraints.maxWidth;
                                                          double screenHeight = constraints.maxHeight;

                                                          String content = articleData['content'] ?? "";
                                                          int contentLength = content.length;

                                                          double fontSize = screenWidth < 800
                                                              ? (contentLength < 200 ? 22 : 25)
                                                              : (contentLength < 200 ? 20 : 18);

                                                          return Text(
                                                            content,
                                                            style: TextStyle(
                                                              fontFamily: 'Open Sans',
                                                              color: Colors.black,
                                                              fontSize: screenWidth < 1250? 22 : 24,
                                                              height: 1.5,
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: screenHeight * 0.06,
                                                  width: screenWidth*1,
                                                  color: Color(0xFFEFF1FD),
                                                  child: Padding(
                                                    padding: EdgeInsets.fromLTRB(8,4,0,0),
                                                    child: Text(
                                                      'Swipe right for more articles/ ${formatDate(articleData['date_time'] ?? "")}',
                                                      style: TextStyle(
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.grey[500],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    width: screenWidth * 1.0,
                                                    color: Color(0xFFEFF1FD),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(18.0), // Adjust the radius as needed
                                                            color: Color(0xFFEFF1FD), // Background color of the button
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () async {
                                                              // Open the link when the article image is clicked
                                                              if (articleData['dest_link'] != null && articleData['dest_link']!.isNotEmpty) {
                                                                if (await canLaunch(articleData['dest_link']!)) {
                                                                  await launch(articleData['dest_link']!);
                                                                } else {
                                                                  print('Could not launch ${articleData['dest_link']}');
                                                                }
                                                              }
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0), // Adjust padding as needed
                                                              child: Text(
                                                                'Read full article',
                                                                style: TextStyle(
                                                                  fontFamily: 'Open Sans',
                                                                  color: Color(0xFF0563C1), // Text color of the button
                                                                  fontSize: isSmallSize ? screenWidth * 0.04 : screenWidth * 0.018,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                              ]
                            ),
                          ),
                        ],
                      ),
                      // ... (Add other widgets if needed)
                    ],
                  ),
                ),



                // for PHONE
  
  
                Visibility(
                  visible: isSmallSize,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: screenWidth * 1.0, // Adjust the width
                              height: screenHeight * 1, // Adjust the height
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, screenHeight * 0.04),
                                child: PageView.builder(
                                  onPageChanged: (index) {
                                    setState(() {
                                      currentIndex = index;
                                      print("currentIndex  $currentIndex");
                                    });
                                  },
                                  controller: _model.pageViewController ??= PageController(initialPage: 0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: articles.length, // Number of pages = number of articles
                                  itemBuilder: (context, index) {
                                    // Get data for the current article
                                    var articleData = articles[index];
  
                                    return Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: GestureDetector(
                                            onTap: () async {
                                              // Open the link when the article image is clicked
                                              if (articleData['dest_link'] != null && articleData['dest_link']!.isNotEmpty) {
                                                if (await canLaunch(articleData['dest_link']!)) {
                                                  await launch(articleData['dest_link']!);
                                                } else {
                                                  print('Could not launch ${articleData['dest_link']}');
                                                }
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(screenWidth * 0.01),
                                              child: Image.network(
                                                articleData['image'] ?? 'https://example.com/placeholder.jpg',
                                                fit: screenWidth<500? BoxFit.fill : BoxFit.fill,
                                                height: screenHeight * 2 / 2.5,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  // Open the link when the article image is clicked
                                                  if (articleData['dest_link'] != null && articleData['dest_link']!.isNotEmpty) {
                                                    if (await canLaunch(articleData['dest_link']!)) {
                                                      await launch(articleData['dest_link']!);
                                                    } else {
                                                      print('Could not launch ${articleData['dest_link']}');
                                                    }
                                                  }
                                                },
                                                child: Container(
                                                  height: screenHeight * 0.15,
                                                  color: Color(0xFFEFF1FD),
                                                  child: LayoutBuilder(
                                                    builder: (BuildContext context, BoxConstraints constraints) {
                                                      return SingleChildScrollView(
                                                        child: Container(
                                                          constraints: BoxConstraints(
                                                            minHeight: constraints.maxHeight,
                                                          ),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.fromLTRB(15,0,0,0),
                                                                child: Text(
                                                                  articleData['title'] ?? "",
                                                                  style: TextStyle(
                                                                    fontFamily: 'Tienne',
                                                                    color: Color(0xFF0563C1),
                                                                    fontSize: screenWidth > 500
                                                                        ? screenWidth * 0.04 * (constraints.maxHeight / (screenHeight * 0.15))
                                                                        : screenWidth * 0.05 * (constraints.maxHeight / (screenHeight * 0.15)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),

                                              Container(
                                                height: screenHeight * 0.32,
                                                color:Color(0xFFEFF1FD),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(8, 0, 2, 0),
                                                  child: SingleChildScrollView(
                                                    child: LayoutBuilder(
                                                      builder: (context, constraints) {
                                                        double screenWidth = constraints.maxWidth;
                                                        double screenHeight = constraints.maxHeight;

                                                        String content = articleData['content'] ?? "";
                                                        int contentLength = content.length;

                                                        double fontSize = contentLength < 500?
                                                        contentLength*screenWidth/12*0.001:22;

                                                        return Text(
                                                          content,
                                                          style: TextStyle(
                                                            fontFamily: 'Open Sans',
                                                            color: Colors.black,
                                                            fontSize: screenWidth < 600? 14: 16,
                                                            height: 1.5,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: screenHeight * 0.05,
                                                width: screenWidth*1,
                                                color:Color(0xFFEFF1FD),
                                                child: Padding(
                                                  padding: EdgeInsets.fromLTRB(0,0,15,0),
                                                  child: Align(
                                                    alignment: Alignment.topRight,
                                                    child: Text(
                                                      'Swipe right for more articles/ ${formatDate(articleData['date_time'] ?? "")}',
                                                      style: TextStyle(
                                                        fontFamily: 'Open Sans',
                                                        color: Colors.grey[500],
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // ... (Add other widgets if needed)
                    ],
                  ),
                ),
              ],
            ),
          ),
  
          // Define the FloatingActionButton here
          floatingActionButton: Align(
            alignment: screenWidth < 500
                ? Alignment(1, -0.78)
                : screenWidth < 1000
                ? Alignment(-0.9, 1)
                : Alignment(-0.97, 1),
            child: FloatingActionButton(
              onPressed: () {
                pageViewController.animateToPage(
                  0,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );

                // Show a snackbar after the button is clicked
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: pageViewController.page == 0? Text('Already at first article'): Text('Back to first article'),
                    duration: Duration(seconds: 1), // Adjust the duration as needed
                    backgroundColor: Color(0xFF639843),
                  ),
                );
              },
              child: Icon(Icons.beach_access),
              backgroundColor: Color(0xFF639843),
            ),
          ),

        ),
      );
    }
  }
