import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:learn_with_usama/models/Unit.dart';
import 'package:learn_with_usama/services/database.dart';


class AddUnitScreen extends StatefulWidget {
  @override
  _AddUnitScreenState createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  String unitName = '';
  String unitNumber = '';
  String payment = '';
  String overviewDescription ='';
  bool _isSubmitting = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Size to fit content
        children: <Widget>[
          Text(
            'Add Unit',
            style: GoogleFonts.nunito(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            onChanged: (value){
              unitName = value;
            },
            decoration: InputDecoration(
              labelText: 'Unit Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            onChanged: (value){
              unitNumber = value;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Unit Number',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            onChanged: (value){
              payment = value;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'payment',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            onChanged: (value){
              overviewDescription =value;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'overviewDescription',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20.0),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Colors.red),
            ),
          SizedBox(height: 20.0),
          _isSubmitting
              ? SpinKitCubeGrid(
            color: Color(0xffF37979),
          )
              : ElevatedButton(
            onPressed: () {
              Database().addUnit(Unit(unitName: unitName,unitNumber: unitNumber, payment: payment,overviewDescription: overviewDescription));
              Navigator.of(context).pop();
            },
            child: Text('Add Unit'),
          ),
        ],
      ),
    );
  }
}
