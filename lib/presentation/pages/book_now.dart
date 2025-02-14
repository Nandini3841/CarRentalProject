import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookNowPage extends StatefulWidget {
  const BookNowPage({super.key});

  @override
  _BookNowPageState createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  DateTime? fromDate;
  DateTime? toDate;
  String? selectedCarType;
  final carRates = {
    'Fortuner VX1 4x4 (Petrol)': 220, // SAR per day
    'Fortuner VX2 Plus 4x4 Diesel': 260,
    'Fortuner GX2 4x2(Petrol)': 150,
    'Fortuner VX2 4x4 Diesel': 240,
    'Fortuner VX3 4x4 (Petrol)': 300,
    'Fortuner GX2 4x4 (Petrol)': 170,
    'Fortuner GX2 4x4 Diesel': 180,
  };

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double totalCost = 0.0;

  Future<void> pickDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime.now();
    DateTime lastDate = DateTime.now().add(const Duration(days: 365));

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
        } else {
          toDate = pickedDate;
        }
      });
    }
  }

  void confirmBooking() {
    if (!_formKey.currentState!.validate() ||
        fromDate == null ||
        toDate == null ||
        selectedCarType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all booking details.")),
      );
      return;
    }

    int days = toDate!.difference(fromDate!).inDays + 1;
    num totalCost = days * (carRates[selectedCarType] ?? 0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Confirmation'),
        content: Text(
          "Thank you for your booking, ${_usernameController.text}!\n\n"
          "Email: ${_emailController.text}\n"
          "Car Type: $selectedCarType\n"
          "From: ${DateFormat('yyyy-MM-dd').format(fromDate!)}\n"
          "To: ${DateFormat('yyyy-MM-dd').format(toDate!)}\n"
          "Total Cost: ${totalCost.toStringAsFixed(2)} SAR",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Car'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Enter Your Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Booking Dates',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(context, true),
                      child: Text(fromDate == null
                          ? 'From Date'
                          : DateFormat('yyyy-MM-dd').format(fromDate!)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickDate(context, false),
                      child: Text(toDate == null
                          ? 'To Date'
                          : DateFormat('yyyy-MM-dd').format(toDate!)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Car Type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedCarType,
                isExpanded: true,
                hint: const Text('Choose a car type'),
                items: carRates.keys.map((carType) {
                  return DropdownMenuItem<String>(
                    value: carType,
                    child: Text(carType),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCarType = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: confirmBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
