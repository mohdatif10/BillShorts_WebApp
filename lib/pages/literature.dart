import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LiteraturePage extends StatelessWidget {
  final List<Map<String, dynamic>> booksData = [
    {
      'title': 'The Wisdom of Finance',
      'author': 'Mihir Desai',
      'dest_url': 'https://www.amazon.com/Wisdom-Finance-Discovering-Humanity-World/dp/054491113X',
      'image': "Wisdomoffinance.jpg",
    },
    {
      'title': 'The Psychology of Money',
      'author': 'Morgan Housel',
      'dest_url': 'https://www.amazon.com/Psychology-Money-Timeless-Lessons-Happiness/dp/B08D9WJ9G8',
      'image': "psychmoney.jpg",
    },
    {
      'title': 'Rich Dad Poor Dad',
      'author': 'Robert T. Kiyosaki',
      'dest_url': 'https://www.amazon.com/Rich-Dad-Poor-Teach-Middle/dp/1612680178',
      'image': "richdad.jpg",
    },
    {
      'title': 'The Personal MBA',
      'author': 'Josh Kaufman',
      'dest_url': 'https://www.amazon.com/Personal-MBA-Master-Art-Business/dp/1591845572',
      'image': "personalMBA.jpg",
    },
    {
      'title': 'One up on Wall Street',
      'author': 'Peter Lynch',
      'dest_url': 'https://www.amazon.com/One-Up-On-Wall-Street/dp/0743200403',
      'image': "oneup.jpg",
    },
    {
      'title': 'Elon Musk',
      'author': 'Ashlee Vance',
      'dest_url': 'https://www.amazon.com/Elon-Musk-SpaceX-Fantastic-Future/dp/0062301233',
      'image': "elon.jpg",
    },
    {
      'title': 'Business Adventures',
      'author': 'John Brooks',
      'dest_url': 'https://www.amazon.com/Business-Adventures-Twelve-Classic-Street/dp/1497644895',
      'image': "businessadv.jpg",
    },
    {
      'title': 'Zero to One',
      'author': 'Peter Thiel',
      'dest_url': 'https://www.amazon.com/Zero-One-Notes-Startups-Future/dp/0804139296',
      'image': "zerotoone.jpg",
    },
    {
      'title': 'The \$100 Startup',
      'author': 'Chris Guillebeau',
      'dest_url': 'https://www.amazon.com/100-Startup-Reinvent-Living-Create/dp/0307951529',
      'image': "hundredstartup.jpg",
    },
    {
      'title': 'Freakonomics',
      'author': 'Steven D. Levitt and Stephen J. Dubner',
      'dest_url': 'https://www.amazon.com/Freakonomics-Economist-Explores-Hidden-Everything/dp/0060731338',
      'image': "freakonomics.jpg",
    },
    {
      'title': 'The Undercover Economist',
      'author': 'Tim Harford',
      'dest_url': 'https://www.amazon.com/Undercover-Economist-Exposing-Want-World/dp/0199926514',
      'image': "undercovereconomist.jpg",
    },

  ];

  final List<Map<String, dynamic>> podcastsData = [
    {
      'title': 'Anshuman Sharma',
      'dest_url': 'https://www.youtube.com/@anshumanfinance',
      'platform': 'Spotify',
      'image': "anshuman.jpg",
    },
    {
      'title': 'The Ramsey Show',
      'dest_url': 'https://www.youtube.com/channel/UC7eBNeDW1GQf2NJQ6G6gAxw',
      'platform': 'YouTube',
      'image': "RamseyShow.jpg",
    },
    {
      'title': 'Planet Money',
      'dest_url': 'https://open.spotify.com/show/4FYpq3lSeQMAhqNI81O0Cn',
      'platform': 'Spotify',
      'image': "planetmoney.png",
    },
    {
      'title': 'Money 101',
      'dest_url': 'https://open.spotify.com/show/5J1b5cpk2tAAd9YMWQ2m32',
      'platform': 'Spotify',
      'image': "Money101.jpg",
    },
    {
      'title': 'Money for the Rest of Us',
      'dest_url': 'https://open.spotify.com/show/6OkOdWqyvKXFjZ1eFHeJxb',
      'platform': 'Spotify',
      'image': "moneyfor.jpg",
    },
    // Add more podcasts here...
  ];

  final List<Map<String, dynamic>> websitesData = [
    {
      'title': 'Inshorts',
      'dest_url': 'https://inshorts.com/',
      'geo' : "India",
      'image': "inshorts.png",
    },
    {
      'title': 'Finshots',
      'dest_url': 'https://finshots.in/',
      'geo' : "India",
      'image': "finshots.jpg",
    },
    {
      'title': 'Finimize',
      'dest_url': 'https://www.finimize.com/',
      'geo' : "Global",
      'image': "finimize.png",
    },
    {
      'title': 'Bloomberg',
      'dest_url': 'https://www.bloomberg.com/markets',
      'geo' : "Global",
      'image': "bloomberg.png",
    },
    {
      'title': 'Yahoo Finance',
      'dest_url': 'https://finance.yahoo.com/',
      'geo' : "Global",
      'image': "yahoof.jpg",
    },
    {
      'title': 'Finology',
      'dest_url': 'https://finology.in/',
      'geo' : "India",
      'image': "finology.png",
    },
    // Add more websites here...
  ];

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
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return isSmallSize
                            ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8.0),
                            Center(
                              child: Text(
                                'Books',
                                style: TextStyle(
                                  fontSize:  isSmallSize ? screenWidth * 0.05 : screenWidth * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF639843),
                                  fontFamily: "Borel",
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: booksData.length,
                              itemBuilder: (context, index) {
                                final book = booksData[index];
                                return ListTile(
                                  onTap: () async {
                                    final url = book['dest_url'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage("assets/${book['image']}"),
                                  ),
                                  title: Text(
                                    book['title'],
                                    style: TextStyle(
                                      fontFamily: 'Crimson',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'by ${book['author']}',
                                    style: TextStyle(
                                      fontFamily: 'Crimson',
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8.0),
                            Center(
                              child: Text(
                                'Podcasts',
                                style: TextStyle(
                                  fontSize:  isSmallSize ? screenWidth * 0.05 : screenWidth * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF639843),
                                  fontFamily: "Borel",
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: podcastsData.length,
                              itemBuilder: (context, index) {
                                final podcast = podcastsData[index];
                                return ListTile(
                                  onTap: () async {
                                    final url = podcast['dest_url'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage("assets/${podcast['image']}"),
                                  ),
                                  title: Text(
                                    podcast['title'],
                                    style: TextStyle(
                                      fontFamily: 'Crimson',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'on ${podcast['platform']}',
                                    style: TextStyle(
                                      fontFamily: 'Crimson',
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 8.0),
                            Center(
                              child: Text(
                                'Tools',
                                style: TextStyle(
                                  fontSize:  isSmallSize ? screenWidth * 0.05 : screenWidth * 0.025,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF639843),
                                  fontFamily: "Borel",
                                ),
                              ),
                            ),
                            SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: websitesData.length,
                              itemBuilder: (context, index) {
                                final website = websitesData[index];
                                return ListTile(
                                  onTap: () async {
                                    final url = website['dest_url'];
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                  leading: CircleAvatar(
                                    radius: 20,
                                    backgroundImage: AssetImage("assets/${website['image']}"),
                                  ),
                                  title: Text(
                                    website['title'],
                                    style: TextStyle(
                                      fontFamily: 'Crimson',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'for ${website['geo']}',
                                    style: TextStyle(
                                      fontFamily: 'Crimson',
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        )


                        // for LARGE screen


                            : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.0),
                                  Center(
                                    child: Text(
                                      'Books',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF639843),
                                        fontFamily: "Borel",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: booksData.length,
                                    itemBuilder: (context, index) {
                                      final book = booksData[index];
                                      return ListTile(
                                        onTap: () async {
                                          final url = book['dest_url'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage("assets/${book['image']}"),
                                        ),
                                        title: Text(
                                          book['title'],
                                          style: TextStyle(
                                            fontFamily: 'Crimson',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'by ${book['author']}',
                                          style: TextStyle(
                                            fontFamily: 'Crimson',
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.0),
                                  Center(
                                    child: Text(
                                      'Podcasts',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF639843),
                                        fontFamily: "Borel",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: podcastsData.length,
                                    itemBuilder: (context, index) {
                                      final podcast = podcastsData[index];
                                      return ListTile(
                                        onTap: () async {
                                          final url = podcast['dest_url'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage("assets/${podcast['image']}"),
                                        ),
                                        title: Text(
                                          podcast['title'],
                                          style: TextStyle(
                                            fontFamily: 'Crimson',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'on ${podcast['platform']}',
                                          style: TextStyle(
                                            fontFamily: 'Crimson',
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8.0),
                                  Center(
                                    child: Text(
                                      'Tools',
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF639843),
                                        fontFamily: "Borel",
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.0),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: websitesData.length,
                                    itemBuilder: (context, index) {
                                      final website = websitesData[index];
                                      return ListTile(
                                        onTap: () async {
                                          final url = website['dest_url'];
                                          if (await canLaunch(url)) {
                                            await launch(url);
                                          } else {
                                            throw 'Could not launch $url';
                                          }
                                        },
                                        leading: CircleAvatar(
                                          radius: 20,
                                          backgroundImage: AssetImage("assets/${website['image']}"),
                                        ),
                                        title: Text(
                                          website['title'],
                                          style: TextStyle(
                                            fontFamily: 'Crimson',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'for ${website['geo']}',
                                          style: TextStyle(
                                            fontFamily: 'Crimson',
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 8), // Add some spacing
                  Text(
                    "*Please note that the provided recommendations are a selection of greatly useful resources for me, my friends, and mentors of similar thought. The reccommended books, podcasts, and websites, are for informational purposes only and have not all been personally tested. Use personal discretion before making any financial decisions based on this content.",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: isSmallSize? 11:14,
                      color: Colors.black,
                      fontFamily: "Crimson",
                    ),
                  ),
                ],
            ),
          ),
        ),
    );
  }
}
