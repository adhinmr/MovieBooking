import 'package:flutter/material.dart';

class SeatBookingPage extends StatefulWidget {
  const SeatBookingPage({super.key});

  @override
  State<SeatBookingPage> createState() => _SeatBooingPageState();
}

class _SeatBooingPageState extends State<SeatBookingPage> {
  final int rows = 5;
  final int columns = 8;
  final double seatPrice = 150.0; // Price per seat

  // Track selected seats using a set of seat indices
  final Set<int> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seat Booking"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                ),
                itemCount: rows * columns,
                itemBuilder: (context, index) {
                  final isSelected = selectedSeats.contains(index);
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSeats.remove(index);
                        } else {
                          selectedSeats.add(index);
                        }
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Center(
                        child: Text(
                          "Seat ${index + 1}",
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Selected Seats: ${selectedSeats.length}",
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  "Total Price: ${(selectedSeats.length * seatPrice).toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
