import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ArticleManager extends ChangeNotifier {
  List<Map<String, String>> articles = [];
  int jsonDumpLength = 0;

  Future<List<Map<String, String>>> fetchArticles() async {
    try {
      var firestore = FirebaseFirestore.instance;
      var collectionReference = firestore.collection('archive');

      var snapshot = await collectionReference
          .orderBy('article_number', descending: true)
          .limit(100) // Limit the number of documents to 100
          .get();

      if (snapshot.docs.isNotEmpty) {
        var fetchedArticles = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;

          String id = doc.id;
          String title = data['title'] as String? ?? '';
          String content = data['content'] as String? ?? '';
          String image = data['image_url'] as String? ?? '';
          String dest_link = data['dest_link'] as String? ?? '';

          String date_time =
          data['date_time'] == null ? '' : data['date_time'].toString();
          String article_number =
          data['article_number'] == null ? '0' : data['article_number'].toString();

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

        fetchedArticles.sort((a, b) {
          int articleNumberA = int.parse(a['article_number'] ?? '0');
          int articleNumberB = int.parse(b['article_number'] ?? '0');
          return articleNumberA.compareTo(articleNumberB);
        });

        articles = List<Map<String, String>>.from(fetchedArticles.reversed);
        jsonDumpLength = articles.length;

        print("Fetched Articles $articles"); // Add this line to print a header

        notifyListeners();

        return articles; // Return the fetched articles
      } else {
        print("No Docs received in fetchArticles()");
        return []; // Return an empty list if no documents are received
      }
    } catch (error) {
      print('Request error: $error');
      return []; // Return an empty list in case of an error
    }
  }
}
