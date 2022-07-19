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
        title: const Text('Search Available Jobs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Profile Page',
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Job History and Updates',
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Profile Alias',
                          ),
                          Text(
                            'First Name',
                          ),
                          Text(
                            'Last Name',
                          ),
                          Text(
                            'Contact Type',
                          ),
                          Text(
                            'Contact Value',
                          ),
                        ],
                      ),
                    ],
                  )
                ])
              ],
            ),
          ],
        ),
      ),
    );
  }
}
