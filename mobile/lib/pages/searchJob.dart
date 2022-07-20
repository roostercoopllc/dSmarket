import 'package:flutter/material.dart';

class SearchJobPage extends StatefulWidget {
  const SearchJobPage({Key? key}) : super(key: key);

  @override
  State<SearchJobPage> createState() => _SearchJobState();
}

class _SearchJobState extends State<SearchJobPage> {
  final _JobSearchKey = GlobalKey<FormState>();

  List<Object> _jobList = ['1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Search Jobs'),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _JobSearchKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Search Available Jobs',
                        ),
                      ],
                    ),
                    Text(
                      'Search by Job Title',
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    for (var i in _jobList)
                      Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const ListTile(
                              leading: Icon(Icons.album),
                              title: Text('The Enchanted Nightingale'),
                              subtitle: Text(
                                  'Music by Julie Gable. Lyrics by Sidney Stein.'),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: const Text('BUY TICKETS'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('LISTEN'),
                                  onPressed: () {/* ... */},
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ))));
  }
}
