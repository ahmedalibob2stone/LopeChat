import 'package:flutter/material.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to get screen size and adapt layout accordingly
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Web Screen Layout'),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar for larger screens
          if (screenSize.width > 1200)
            Container(
              width: 250,
              color: Colors.blueGrey[100],
              child: ListView(
                children: [
                  ListTile(title: Text('Home')),
                  ListTile(title: Text('Profile')),
                  ListTile(title: Text('Settings')),
                  // Add more items as needed
                ],
              ),
            ),
          // Main content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Main Content Area',
                    style: TextStyle(
                      fontSize: screenSize.width > 800 ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'This is where the main content will go. '
                        'On smaller screens, this content will take up the full width.',
                  ),
                  // Add more widgets as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
