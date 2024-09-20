import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../services/payHere.dart';

class PaymentFormPagePaper extends StatefulWidget {
  final String fixedAmount;
  final String paperId; // Pass the Unit's document ID

  const PaymentFormPagePaper({
    Key? key,
    required this.fixedAmount,
    required this.paperId, // Accept the unitId as a parameter
  }) : super(key: key);

  @override
  _PaymentFormPageState createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPagePaper> {
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pay for Unit'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter Payment Details for Paper',
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
                      _makePaymentForPaper(widget.paperId); // Pass unitId to payment function
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

  // Function to trigger payment for the unit

  void _makePaymentForPaper(String paperId) {
    setState(() {
      isLoading = true;
    });

    // Payment logic
    PayHereService.makePayment(
      isSandbox: true, // Sandbox mode
      merchantId: "1211149", // Replace with actual Merchant ID
      merchantSecret: "xyz", // Replace with actual Merchant Secret
      orderId: "Order_$paperId", // Use the unit's ID in the order ID
      items: "Unit Payment", // Description of the item
      amount: widget.fixedAmount, // Fixed payment amount
      currency: "LKR", // Currency type
      firstName: firstNameController.text,
      lastName: lastNameController.text,
      email: emailController.text,
      phone: phoneController.text,
      address: "No.1, Main Street", // Sample address
      city: "Colombo", // Sample city
      country: "Sri Lanka", // Sample country
      notifyUrl: "https://your-backend-url.com/notify", // Backend notification URL (optional)
      onSuccess: (paymentId) async {
        // Update payment status in Firestore for the specific unit
        await _updatePaperPaymentStatus(paperId, paymentId);


        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful for Unit: $paperId")),
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
  Future<void> _updatePaperPaymentStatus(String paperId, String paymentId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('papers').doc(paperId).update({
        'paymentStatus': 'paid',
        'paymentId': paymentId,
        'userId': user.uid,
        'paidAmount': widget.fixedAmount,
        'paymentDate': FieldValue.serverTimestamp(),
      });
    }
  }

  // Helper function to build text fields
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

  // Helper function to display fixed amount
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
