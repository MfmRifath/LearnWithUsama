import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../services/payHere.dart';

class PaymentFormPage extends StatefulWidget {
  final String fixedAmount;

  const PaymentFormPage({
    Key? key,
    required this.fixedAmount,
  }) : super(key: key);
  @override
  _PaymentFormPageState createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> {
  bool _hasPaid = false;

  Future<void> _checkPaymentStatus() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot paymentDoc = await FirebaseFirestore.instance
            .collection('payments')
            .doc(user.uid)
            .get();
        setState(() {
          _hasPaid = paymentDoc.exists && paymentDoc['status'] == 'paid';
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error checking payment status: $e');
      }
    }
  }
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  // The fixed amount value (e.g., 100.00 LKR)

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay with PayHere'),
        backgroundColor: Colors.teal, // Consistent color branding
      ),
      body: isLoading
          ? Center(child: SpinKitPouringHourGlass(color: Colors.green))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Payment Details',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                SizedBox(height: 20),
                // First Name Input
                buildTextField(
                  controller: firstNameController,
                  labelText: "First Name",
                  hintText: "Enter your first name",
                  icon: Icons.person,
                ),
                SizedBox(height: 16),
                // Last Name Input
                buildTextField(
                  controller: lastNameController,
                  labelText: "Last Name",
                  hintText: "Enter your last name",
                  icon: Icons.person_outline,
                ),
                SizedBox(height: 16),
                // Email Input
                buildTextField(
                  controller: emailController,
                  labelText: "Email",
                  hintText: "Enter your email",
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                // Phone Number Input
                buildTextField(
                  controller: phoneController,
                  labelText: "Phone",
                  hintText: "Enter your phone number",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                Divider(height: 32, thickness: 2, color: Colors.teal[200]),
                // Display Fixed Amount (Uneditable)
                buildFixedAmountField(widget.fixedAmount),
                SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _makePayment();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Pay Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to trigger payment
  void _makePayment() {
    setState(() {
      isLoading = true;
    });

    PayHereService.makePayment(
      isSandbox: true, // Set to true for sandbox mode, false for live
      merchantId: "1211149", // Replace with your actual Merchant ID
      merchantSecret: "xyz", // Replace with your actual Merchant Secret
      orderId: "Order12345", // Replace with unique order ID
      items: "Sample Payment", // Replace with item description
      amount: widget.fixedAmount, // Use the fixed, unchangeable amount here
      currency: "LKR", // Currency, e.g., "LKR" or "USD"
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: "No.1, Main Street", // Sample address
      city: "Colombo", // Sample city
      country: "Sri Lanka", // Sample country
      notifyUrl: "https://your-backend-url.com/notify", // Optional backend notification URL
      onSuccess: (paymentId) async {
        // Update payment status in Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance.collection('payments').doc(user.uid).set({
            'status': 'paid',
            'paymentId': paymentId,
            'amount': widget.fixedAmount,
            // Include any other relevant payment details
          });
          // Refresh the payment status
          _checkPaymentStatus();
        }
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful: $paymentId")),
        );
      },
      onError: (error) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Failed: $error")),
        );
      },
      onDismiss: () {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Dismissed")),
        );
      },
    );
  }


  // Function to build input fields
  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }

  // Function to build the fixed amount field
  Widget buildFixedAmountField(String amount) {
    return TextFormField(
      initialValue: amount,
      enabled: false,
      decoration: InputDecoration(
        labelText: "Amount (LKR)",
        prefixIcon: Icon(Icons.money, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
