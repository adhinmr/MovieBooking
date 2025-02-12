import 'package:flutter/material.dart';
import 'package:movie_booking_app/provider/moviebooking_provider.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<MovieBookingProvider>(
        builder: (context, provider, child) {
          return Container( height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade500],
          ),
        ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Booking Summary Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Summary',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _buildSummaryItem('Movie', provider.selectedMovieTitle ?? ''),
                          _buildSummaryItem('Date', provider.selectedDate?.toString().split(' ')[0] ?? ''),
                          _buildSummaryItem('Theater', provider.selectedTheater ?? ''),
                          _buildSummaryItem('Showtime', provider.selectedShowtime ?? ''),
                          _buildSummaryItem('Seats', provider.selectedSeats.join(', ')),
                          const Divider(),
                          _buildSummaryItem('Total Amount', '₹${provider.calculateTotalPrice()}'),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Payment Methods
                  Text(
                    'Select Payment Method',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  
                  // Payment Method Cards
                  _buildPaymentMethodCard(
                    context,
                    provider,
                    PaymentMethod.creditCard,
                    Icons.credit_card,
                    'Credit Card',
                  ),
                  _buildPaymentMethodCard(
                    context,
                    provider,
                    PaymentMethod.debitCard,
                    Icons.credit_card,
                    'Debit Card',
                  ),
                  _buildPaymentMethodCard(
                    context,
                    provider,
                    PaymentMethod.upi,
                    Icons.account_balance,
                    'UPI',
                  ),
                  _buildPaymentMethodCard(
                    context,
                    provider,
                    PaymentMethod.netBanking,
                    Icons.account_balance,
                    'Net Banking',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Pay Now Button
                  ElevatedButton(
                    onPressed: provider.selectedPaymentMethod == null || provider.isProcessingPayment
                        ? null
                        : () => _processPayment(context, provider),
                    child: provider.isProcessingPayment
                        ? const CircularProgressIndicator()
                        : const Text('Pay Now'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    BuildContext context,
    MovieBookingProvider provider,
    PaymentMethod method,
    IconData icon,
    String title,
  ) {
    final isSelected = provider.selectedPaymentMethod == method;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: isSelected ? const Icon(Icons.check_circle) : null,
        onTap: () => provider.selectPaymentMethod(method),
      ),
    );
  }

  Future<void> _processPayment(BuildContext context, MovieBookingProvider provider) async {
    final success = await provider.processPayment();
    
    if (!context.mounted) return;

    if (success) {
      // Show success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Payment Successful'),
          content: Text('Transaction ID: ${provider.transactionId}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      );
    } else {
      // Show error dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Payment Failed'),
          content: const Text('Please try again or choose a different payment method.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                provider.resetPayment();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}