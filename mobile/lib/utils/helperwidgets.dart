import 'package:flutter/material.dart';

class JobViewCard extends StatelessWidget {
  const JobViewCard({
    Key? key,
    this.jobTitle = 'Default Job Title',
    this.jobDescription = 'Default Job Description',
  }) : super(key: key);
  final String jobTitle;
  final String jobDescription;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text(jobTitle),
            subtitle: Text(jobDescription),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Negotiate'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Remove'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
