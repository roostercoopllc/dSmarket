import 'package:flutter/material.dart';

class NegotiateJobPage extends StatefulWidget {
  const NegotiateJobPage({Key? key}) : super(key: key);

  @override
  State<NegotiateJobPage> createState() => _NegotiateJobState();
}

class _NegotiateJobState extends State<NegotiateJobPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Negotaite Jobs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Negotiate Job',
            ),
          ],
        ),
      ),
    );
  }
}
