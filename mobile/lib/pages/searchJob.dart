import 'package:flutter/material.dart';

class SearchJobPage extends StatefulWidget {
  const SearchJobPage({Key? key}) : super(key: key);

  @override
  State<SearchJobPage> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Jobs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Search Jobs Page',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
