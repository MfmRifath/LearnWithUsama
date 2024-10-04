import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learn_with_usama/models/Unit.dart';
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
        title: Text('Pay for Paper Class'),
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
                  'Enter Payment Details for Paper ',
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
                      _makePaymentForUnit(widget.paperId); // Pass unitId to payment function
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
  void _makePaymentForUnit(String paperId) {
    setState(() {
      isLoading = true;
    });

    // Payment logic
    PayHereService.makePayment(
      isSandbox: true, // Sandbox mode
      merchantId: "1228326", // Replace with actual Merchant ID
      merchantSecret: "MTQ2NDM2MTIyMDIyODA0ODMzNTMzODkyNTU0MTQzMDI5NjY3MjQ3", // Replace with actual Merchant Secret
      orderId: "Order_$paperId", // Use the unit's ID in the order ID
      items: "Paper Class Payment", // Description of the item
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
        await _updateUnitPaymentStatus(paperId, paymentId);

        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Successful for Paper Class: $paperId")),
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

  Future<void> _updateUnitPaymentStatus(String paperId, String paymentId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // Query for the document where the 'unitNumber' field matches the provided unitId
        final querySnapshot = await FirebaseFirestore.instance
            .collection('papers')
            .where('paperId', isEqualTo: paperId) // Change this to the field name
            .limit(1)
            .get();

        // Check if any documents are returned
        if (querySnapshot.docs.isEmpty) {
          print("No paper class with paper Id: $paperId found");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Paper with Paper Id: $paperId not found")),
          );
          return;
        }

        // Get the document reference of the first match (since .limit(1) is used)
        final docRef = querySnapshot.docs.first.reference;

        // Update the document if it exists
        await docRef.update({
          'paymentStatus': 'paid',
          'paymentId': FieldValue.arrayUnion([paymentId]),
          'userId': FieldValue.arrayUnion([user.uid]),
          'paymentDate': FieldValue.serverTimestamp(),
        });

        print("Payment status updated successfully for Unit: $paperId");
      } catch (e) {
        print("Error updating payment status for Unit: $paperId, Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating payment status: $e")),
        );
      }
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
