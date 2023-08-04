import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:billshorts_webapp/pages/article_manager.dart';

class JustTitlesPage extends StatefulWidget {
  @override
  _JustTitlesPageState createState() => _JustTitlesPageState();
}

class _JustTitlesPageState extends State<JustTitlesPage> {
  List<Map<String, String>> articles = [];

  @override
  void initState() {
    super.initState();
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    ArticleManager articleManager = ArticleManager();
    List<Map<String, String>> fetchedArticles = await articleManager.fetchArticles();

    setState(() {
      articles = fetchedArticles;
    });
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isSmallSize = screenWidth < 800;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFf9f7f4),
        automaticallyImplyLeading: false,
        actions: isSmallSize
            ? [
          PopupMenuButton<String>(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
            color: Color(0xFF639843),
            elevation: 2,
            onSelected: (value) {
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
              size: 30,
              color: Colors.black,
            ),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'home',
                child: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Crimson',
                    fontSize: 18,
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
              ),PopupMenuItem<String>(
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
            Navigator.pushNamed(context, '/home');
          },
          child: Align(
            alignment:
            isSmallSize ? Alignment(-1, -1) : Alignment(-0.9, -0.5),
            child: Text(
              'Bill \$horts',
              style: TextStyle(
                fontFamily: 'Crimson',
                color: Color(0xFF639843),
                fontSize:
                isSmallSize ? screenWidth * 0.08 : screenWidth * 0.030,
              ),
            ),
          ),
        ),
        centerTitle: false,
        elevation: 1.1,
        toolbarHeight: screenHeight * 0.08,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
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
                  padding: EdgeInsets.fromLTRB(
                      0, screenHeight * 0.03, 0, screenHeight * 0.01),
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
              // Display the list of articles
              Column(
                children: articles.map((article) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      color: Color(0xFFEFF1FD),
                      child: ListTile(
                        onTap: () async {
                          final url = article['dest_link'];
                          if (await canLaunch(url??"")) {
                            await launch(url??"");
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        leading: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(article['image']??""),
                        ),
                        title: Text(
                          article['title']??"",
                          style: TextStyle(
                            fontFamily: 'Crimson',
                            fontSize: screenWidth<700? 18: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
