import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

_sendEmail(String email, String subject, String body) async {
  final Uri _emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': subject,
      'body': body,
    },
  );

  if (await canLaunch(_emailLaunchUri.toString())) {
    await launch(_emailLaunchUri.toString());
  } else {
    throw 'Could not launch email';
  }
}

void _launchGitHubURL() async {
  const String url = 'https://github.com/mohdatif10/BillShorts_WebApp';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _AboutPageState extends State<AboutPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              // Add more PopupMenuItem widgets for other menu items
              // ...
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
        top: true,
        child: SingleChildScrollView(
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
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.12), // Add padding to move the content down
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (BuildContext context, Widget? child) {
                          return Transform.rotate(
                            angle: _controller.value * 2.0 * 3.1415,
                            child: ClipOval(
                              child: CircleAvatar(
                                backgroundImage: AssetImage("assets/logo.png"),
                                backgroundColor: Colors.white, // Set background color to white
                                radius: 100,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Bill \$horts',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontFamily: "Crimson",
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'A NOT-FOR-PROFIT financial news platform',
                        style: TextStyle(
                          fontSize: isSmallSize? 18:22,
                          color: Colors.black,
                          fontFamily: "Crimson",
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        width: screenWidth*0.7,
                        child: Text(
                          'Here, you will find news primarily related to American, Indian, and European markets. Expect to see 60-100 articles per day covering various financial topics and insights. Stay updated and informed with our selection of literature, podcasts, and websites.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallSize? 18:22,
                            color: Colors.black,
                            fontFamily: "Crimson",
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                        child: Text(
                          'All articles are scraped and summarized to 60-75 words using AI tools. Welcome to the new wave of new\$!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallSize? 18:22,
                            color: Colors.black,
                            fontFamily: "Crimson",
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[400], // Set the background color here
                        ),
                        onPressed: () {
                          _launchGitHubURL();
                        },
                        child: Text(
                          'This project is open source and hence, accessible on GitHub',
                          style: TextStyle(
                            fontSize: isSmallSize? screenWidth*0.03:18,
                            color: Colors.black,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey[400], // Set the background color here
                        ),              onPressed: () {
                        _sendEmail('atif@wisc.edu', 'Hello BillShorts Team', '');
                      },
                        child: Text(
                          'If you would like to support or ask queries, contact me at atif@wisc.edu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallSize? screenWidth*0.03:18,
                            color: Colors.black,
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}
