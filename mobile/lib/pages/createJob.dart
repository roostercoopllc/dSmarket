import 'package:flutter/material.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({Key? key}) : super(key: key);

  @override
  State<CreateJobPage> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Jobs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Create Page',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
