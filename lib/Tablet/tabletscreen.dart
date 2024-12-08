import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/Api/api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class TabletScreen extends StatefulWidget {
  const TabletScreen({super.key});

  @override
  TabletScreenState createState() => TabletScreenState();
}

class TabletScreenState extends State<TabletScreen> {
  TextEditingController searchController = TextEditingController();
  List<MovieApi> allMovies = [];
  List<MovieApi> filteredMovies = [];
  List<MovieApi> suggestions = [];

  Future<void> fetchData() async {
    final url = Uri.parse('https://my-json-server.typicode.com/horizon-code-academy/fake-movies-api/movies');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          allMovies = data.map((json) => MovieApi.fromJson(json)).toList();
          filteredMovies = allMovies; // Initially display all movies
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  void filterMovies(String query) {
    final results = allMovies.where((movie) {
      final titleLower = movie.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredMovies = results;

      // Update suggestions for dropdown
      if (query.isEmpty) {
        suggestions = [];
      } else {
        suggestions = results;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    searchController.addListener(() {
      filterMovies(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120), // Adjusted height for the search bar and suggestions
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              // Display movie suggestions
              if (suggestions.isNotEmpty)
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: suggestions.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final movie = suggestions[index];
                      return GestureDetector(
                        onTap: () {
                          searchController.text = movie.title;
                          filterMovies(movie.title); // Filter for the selected movie
                        },
                        child: Container(
                          child: Card(
                            elevation: 2,
                            color: Colors.grey[200],
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                movie.title,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
      body: filteredMovies.isEmpty
          ? const Center(child: Text('No movies found.'))
          : LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          int crossAxisCount = (width / 250).floor();

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20,
              childAspectRatio: 0.55,
            ),
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              final movie = filteredMovies[index];
              return Card(
                color: Colors.white,
                elevation: 10,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        imageUrl: movie.poster ?? '',
                        width: width / (crossAxisCount * 1.2),
                        height: width / (crossAxisCount * 0.8),
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image, size: 50),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        style: GoogleFonts.poppins(
                          fontSize: width < 1200 ? 16 : 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Year: ${movie.year}\nRuntime: ${movie.runtime}",
                        style: GoogleFonts.poppins(
                          fontSize: width < 600 ? 12 : 14,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
