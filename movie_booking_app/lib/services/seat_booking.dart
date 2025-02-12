import 'package:flutter/material.dart';
import 'package:movie_booking_app/provider/moviebooking_provider.dart';
import 'package:movie_booking_app/provider/payment_provider.dart';
import 'package:provider/provider.dart';

class SeatBookingPage extends StatefulWidget {
  const SeatBookingPage({super.key});

  @override
  State<SeatBookingPage> createState() => _SeatBooingPageState();
}

class _SeatBooingPageState extends State<SeatBookingPage> {
  final int rows = 8;
  final int columns = 8;
  final int balcony = 5;
  final double seatPrice = 150.0;

  final Set<int> selectedSeats = {};

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieBookingProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Seat Booking",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade500],
          ),
        ),
        child: Column(
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
                      return Consumer<MovieBookingProvider>(
                          builder: (context, provider, child) {
                        final isSelected =
                            provider.selectedSeats.contains(index);

                        return GestureDetector(
                          onTap: () {
                            provider.toggleSeat(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  isSelected ? Colors.green : Colors.grey[300],
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            child: Center(
                              child: Text(
                                " ${index + 1}",
                                style: TextStyle(
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    }),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PaymentScreen()));
                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE31E24),
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Total Price: ${provider.calculateTotalPrice().toStringAsFixed(2)} ",
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
