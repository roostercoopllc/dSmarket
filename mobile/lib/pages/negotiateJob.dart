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
        title: const Text('Negotiate Jobs'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Negotiate Job Page',
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
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Message to Employer',
                          ),
                          Text(
                            'Proposed Update',
                          ),
                          Text(
                            'Proposed Start Date',
                          ),
                          Text(
                            'Proposed Salary',
                          ),
                          Text(
                            'Expected Duration',
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
