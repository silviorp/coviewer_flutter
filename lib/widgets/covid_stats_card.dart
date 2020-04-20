import 'package:flutter/material.dart';

class CovidStatCard extends StatelessWidget {
  CovidStatCard({this.color, this.text, this.value, this.newValue});

  final Color color;
  final String text;
  final int value;
  final int newValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 120.0,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: color,
        ),
        child: Column(
          children: <Widget>[
            Text(
              '$text',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            Text(
              '$value',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            Expanded(
              child: Container(),
            ),
            Text(
              'Daily',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
            Text(
              '$newValue',
              style: TextStyle(
                  color: Colors.grey[200],
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
