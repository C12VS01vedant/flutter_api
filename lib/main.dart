import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<Album> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
    // Send authorization headers to the backend.
    headers: {
      HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
    },
  );

  if (response.statusCode == 200) {
    final responseJson = jsonDecode(response.body) as Map<String, dynamic>;
    return Album.fromJson(responseJson);
  } else {
    throw Exception('Failed to load album. Status code: ${response.statusCode}');
  }
}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('userId') &&
        json.containsKey('id') &&
        json.containsKey('title')) {
      return Album(
        userId: json['userId'] as int,
        id: json['id'] as int,
        title: json['title'] as String,
      );
    } else {
      throw const FormatException('Failed to load album.');
    }
  }
}

void main() async {
  try {
    final album = await fetchAlbum();
    print('Album details: ${album.title}');
  } catch (e) {
    print('Error: $e');
  }
}
