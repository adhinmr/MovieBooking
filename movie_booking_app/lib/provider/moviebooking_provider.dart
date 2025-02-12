import 'package:flutter/material.dart';

enum PaymentStatus { pending, processing, completed, failed }
enum PaymentMethod { creditCard, debitCard, upi, netBanking }

class MovieBookingProvider extends ChangeNotifier {
  // Existing Movie Selection State
  String? _selectedMovieTitle;
  String? _selectedMovieImagePath;
  
  // Booking Details
  DateTime? _selectedDate;
  String? _selectedTheater;
  String? _selectedShowtime;
  
  // Seat Booking State
  final Set<int> _selectedSeats = {};
  final double _seatPrice = 150.0;
  
  // Payment State
  PaymentStatus _paymentStatus = PaymentStatus.pending;
  PaymentMethod? _selectedPaymentMethod;
  String? _transactionId;
  bool _isProcessingPayment = false;
  
  // Getters for existing properties
  String? get selectedMovieTitle => _selectedMovieTitle;
  String? get selectedMovieImagePath => _selectedMovieImagePath;
  DateTime? get selectedDate => _selectedDate;
  String? get selectedTheater => _selectedTheater;
  String? get selectedShowtime => _selectedShowtime;
  Set<int> get selectedSeats => _selectedSeats;
  double get seatPrice => _seatPrice;
  
  // New getters for payment
  PaymentStatus get paymentStatus => _paymentStatus;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;
  String? get transactionId => _transactionId;
  bool get isProcessingPayment => _isProcessingPayment;
  
  // Existing methods
  void selectMovie(String title, String imagePath) {
    _selectedMovieTitle = title;
    _selectedMovieImagePath = imagePath;
    notifyListeners();
  }
  
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
  
  void selectTheater(String theater) {
    _selectedTheater = theater;
    notifyListeners();
  }
  
  void selectShowtime(String showtime) {
    _selectedShowtime = showtime;
    notifyListeners();
  }
  
  void toggleSeat(int seatIndex) {
    if (_selectedSeats.contains(seatIndex)) {
      _selectedSeats.remove(seatIndex);
    } else {
      _selectedSeats.add(seatIndex);
    }
    notifyListeners();
  }
  
  double calculateTotalPrice() {
    return _selectedSeats.length * _seatPrice;
  }
  
  bool isBookingComplete() {
    return _selectedDate != null &&
           _selectedTheater != null &&
           _selectedShowtime != null &&
           _selectedSeats.isNotEmpty;
  }
  
  // New payment-related methods
  void selectPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }
  
  Future<bool> processPayment() async {
    if (!isBookingComplete() || _selectedPaymentMethod == null) {
      return false;
    }
    
    try {
      _isProcessingPayment = true;
      _paymentStatus = PaymentStatus.processing;
      notifyListeners();
      
      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 2));
      
      // Generate a mock transaction ID
      _transactionId = 'TXN${DateTime.now().millisecondsSinceEpoch}';
      _paymentStatus = PaymentStatus.completed;
      _isProcessingPayment = false;
      notifyListeners();
      return true;
    } catch (e) {
      _paymentStatus = PaymentStatus.failed;
      _isProcessingPayment = false;
      notifyListeners();
      return false;
    }
  }
  
  void resetPayment() {
    _paymentStatus = PaymentStatus.pending;
    _selectedPaymentMethod = null;
    _transactionId = null;
    _isProcessingPayment = false;
    notifyListeners();
  }
  
  Map<String, dynamic> getBookingSummary() {
    return {
      'movieTitle': _selectedMovieTitle,
      'date': _selectedDate,
      'theater': _selectedTheater,
      'showtime': _selectedShowtime,
      'seats': _selectedSeats.toList(),
      'totalAmount': calculateTotalPrice(),
      'transactionId': _transactionId,
      'paymentStatus': _paymentStatus,
    };
  }
}