import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = 'dde1b0947878977ea278cf2b05a7368b';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  // Helper method to build API URL
  Uri _buildUrl(String endpoint) {
    return Uri.parse('$_baseUrl$endpoint?api_key=$_apiKey');
  }

  // Generalized function to handle API calls and JSON decoding
  Future<Map<String, dynamic>?> _fetchData(Uri url) async {
    try {
      print('Fetching data from: $url'); // Log URL
      final response = await http.get(url).timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        print('Success: Data fetched successfully');
        return json.decode(response.body);
      } else {
        print('Error ${response.statusCode}: ${response.reasonPhrase}');
        return null;
      }
    } on TimeoutException {
      print('Request timed out: $url');
      return null;
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }

  // Fetches popular movies with added error handling
  Future<List<Map<String, dynamic>>> fetchPopularMovies() async {
    final url = _buildUrl('/movie/popular');
    final data = await _fetchData(url);
    if (data != null && data.containsKey('results')) {
      print('Movies fetched: ${data['results'].length} items'); // Log number of movies
      return List<Map<String, dynamic>>.from(data['results']);
    }
    print('No movies found or error occurred.');
    return []; // Return empty list if no results found
  }

  // Fetches movie details by ID with added error handling
  Future<Map<String, dynamic>?> fetchMovieDetails(int movieId) async {
    final url = _buildUrl('/movie/$movieId');
    final data = await _fetchData(url);
    if (data != null) {
      print('Movie details fetched for ID $movieId'); // Log movie ID
    } else {
      print('Failed to fetch details for movie ID $movieId');
    }
    return data;
  }
}
