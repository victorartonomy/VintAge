/*

CONSTRAINED SCAFFOLD:

Normal scaffold but with width constraints

 */
import 'package:flutter/material.dart';

class ConstrainedWebScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Color backgroundColor;
  final bool extendBodyBehindAppBar;

  const ConstrainedWebScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    required this.backgroundColor,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 530*2,
          ), // apply global constraints here
          child: body,
        ),
      ),
    );
  }
}
