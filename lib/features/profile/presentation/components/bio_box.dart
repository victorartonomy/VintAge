import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;
  const BioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(

      // padding
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        // color
        color: Theme.of(context).colorScheme.secondary,
        // radius
        borderRadius: BorderRadius.circular(5),
      ),

      width: double.infinity,

      // text
      child: Text(
        text.isNotEmpty ? text : 'Empty bio', style: TextStyle(color: Theme.of(context).colorScheme.primary),
      )
    );
  }
}
