import 'dart:html';

import 'package:flutter/material.dart';

class AnnouncementContentPage extends StatelessWidget {
  const AnnouncementContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Content"),
      ),
      body: Text("This is announcement content page."),
    );
  }
}
