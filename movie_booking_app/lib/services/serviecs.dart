

//   Future<void> fetchMovies() async {
//   setState(() {
//     _isLoading = true;  // Set loading state to show the indicator
//   });

//   try {
//     // Step 1: Make an API request using the `http` package
//     final response = await http.get(Uri.parse(''));  // Replace with actual API URL
    
//     // Step 2: Check if the request was successful (HTTP status code 200)
//     if (response.statusCode == 200) {
//       // Step 3: Parse the response body into JSON
//       final data = json.decode(response.body);

//       // Step 4: Update the state with fetched movies
//       setState(() {
//         _moviesInTheater = data['movies_in_theater'];  // Assign movies in theater data
//         _upcomingMovies = data['upcoming_movies'];     // Assign upcoming movies data
//         _isLoading = false;  // Stop loading once data is fetched
//       });
//     } else {
//       // If the server returns a status code other than 200, throw an exception
//       throw Exception('Failed to load movies');
//     }
//   } catch (error) {
//     // Handle any kind of error, such as network issues
//     setState(() {
//       _isLoading = false;  // Stop loading on error
//     });
//     print('Error fetching movies: $error');  
//   }
// }

