import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movie_booking_app/provider/moviebooking_provider.dart';
import 'package:movie_booking_app/services/seat_booking.dart';
import 'package:provider/provider.dart';

class MovieBookingPage extends StatefulWidget {
  final String title;
  final String imagePath;
  const MovieBookingPage({Key? key, required this.title, required this.imagePath}) : super(key: key);

  @override
  State<MovieBookingPage> createState() => _MovieBookingPageState();
}

class _MovieBookingPageState extends State<MovieBookingPage>  {
  DateTime? _selectedDate;
  

  final List<String> _theaters = [
    'Palaxi Cinimas HILITE MALL', 
    'Ashirvad Cineplexx',
    'E Max cinimas Dolby',
    'ARC Coronation 4k Dolby Atmos'
  ];
  final List<String> _showtimes = ['10:00 AM', '1:00 PM', '4:00 PM', '7:00 PM'];

  List<DateTime> _getNext30Days() {
    return List<DateTime>.generate(30, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    final provider =Provider.of<MovieBookingProvider>(context);
    String? selectedTheater = Provider.of<MovieBookingProvider>(context).selectedTheater;
    String? selectedShowtime= Provider.of<MovieBookingProvider>(context).selectedShowtime;
    List<DateTime> next30Days = _getNext30Days();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, 
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.network(
              widget.imagePath,
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Poster
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.imagePath,
                          width: 150,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.error, size: 50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Date Selection
                    Text(
                      'Select Date',
                      style: GoogleFonts.aBeeZee(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: next30Days.length,
                        itemBuilder: (context, index) {
                          DateTime date = next30Days[index];
                          bool isSelected = _selectedDate != null && 
                              _selectedDate!.isAtSameMomentAs(date);
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () {

                              provider.selectDate(date);
                              },
                              child: Container(
                                width: 70,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue : Colors.white24,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('EEE').format(date),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white70,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      DateFormat('d').format(date),
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : Colors.white70,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Theater Selection
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Theater',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        value: selectedTheater,
                        dropdownColor: Colors.black87,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items: _theaters.map((String theater) {
                          return DropdownMenuItem<String>(
                            value: theater,
                            child: Text(theater),
                          );
                        }).toList(),
                        onChanged: (newValue) {

                       provider.selectTheater(newValue!);
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Showtime Selection
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text(
                          'Select Showtime',
                          style: GoogleFonts.aBeeZee(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        value: selectedShowtime,
                        dropdownColor: Colors.black87,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        items: _showtimes.map((String showtime) {
                          return DropdownMenuItem<String>(
                            value: showtime,
                            child: Text(showtime),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                       provider.selectShowtime(newValue!);
                        },
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Proceed Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final provider = Provider.of<MovieBookingProvider>(context,listen:false);
                          if (provider.selectedDate!= null&&
                          provider.selectedTheater != null&&
                          provider.selectedShowtime!=null ) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE31E24),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      "Booking Details",
                                      style: TextStyle(color: Colors.white),
                                      
              
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Movie: ${widget.title}"),
                                      Text("Date: ${DateFormat('yyyy-MM-dd').format(provider.selectedDate!)}"),
                                      Text("Theater: ${provider.selectedTheater}"),
                                      Text("Showtime: ${provider.selectedShowtime}"),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => const SeatBookingPage()
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Proceed",
                                        style: TextStyle(color: Color(0xFFE31E24)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select date, theater, and showtime"),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE31E24),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Proceed to Seat Selection",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
