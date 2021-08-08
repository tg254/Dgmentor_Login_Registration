import 'package:flutter/material.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

DateTime date;

class _CalenderState extends State<Calender> {
  String getText() {
    if (date == null) {
      return 'Birth Day';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        GestureDetector(
            onTap: () => pickDate(context), child: Icon(Icons.calendar_today))
      ],
    );
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: initialDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (newDate == null) return;
    setState(() => date = newDate);
  }
}

const List<String> education = [
  'Non',
  'Primary',
  'Secondary',
  'Graduate',
  'Post Graduate'
];
const List<String> departtlist = ['Non', 'Operations', 'Technology', 'Other'];
