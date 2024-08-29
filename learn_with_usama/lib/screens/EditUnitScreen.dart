import 'package:flutter/material.dart';
import '../models/Unit.dart';
import '../services/database.dart';

class EditUnitScreen extends StatefulWidget {
  final Unit unit;

  const EditUnitScreen({Key? key, required this.unit}) : super(key: key);

  @override
  _EditUnitScreenState createState() => _EditUnitScreenState();
}

class _EditUnitScreenState extends State<EditUnitScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _unitNameController;
  late TextEditingController _unitNumberController;
  late TextEditingController _paymentController;
  late TextEditingController _overviewDescriptionController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _unitNameController = TextEditingController(text: widget.unit.unitName);
    _unitNumberController = TextEditingController(text: widget.unit.unitNumber);
    _paymentController = TextEditingController(text: widget.unit.payment);
    _overviewDescriptionController = TextEditingController(text: widget.unit.overviewDescription);
  }

  @override
  void dispose() {
    _unitNameController.dispose();
    _unitNumberController.dispose();
    _paymentController.dispose();
    _overviewDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Unit updatedUnit = Unit(
        documentId: widget.unit.documentId,
        unitName: _unitNameController.text.trim(),
        unitNumber: _unitNumberController.text.trim(),
        payment: _paymentController.text.trim(),
        overviewDescription: _overviewDescriptionController.text.trim(),
      );

      try {
        await Database().updateUnit(updatedUnit);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unit updated successfully')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update unit: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Unit'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: AbsorbPointer(
          absorbing: _isLoading,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _unitNameController,
                  decoration: InputDecoration(
                    labelText: 'Unit Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a unit name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _unitNumberController,
                  decoration: InputDecoration(
                    labelText: 'Unit Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a unit number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _paymentController,
                  decoration: InputDecoration(
                    labelText: 'Payment',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a payment amount';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _overviewDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Overview Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an overview description';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24.0),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: _saveChanges,
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
