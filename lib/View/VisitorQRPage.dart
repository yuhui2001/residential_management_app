import 'dart:html';

import 'package:flutter/material.dart';

class VisitorQRPage extends StatelessWidget {
  const VisitorQRPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitation details"),
      ),
      body: Text("This is invitation details page."),
    );
  }
}