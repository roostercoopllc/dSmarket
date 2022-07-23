import 'package:flutter/material.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({Key? key}) : super(key: key);

  @override
  State<CreateJobPage> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJobPage> {
  final _JobCreateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Create Job'),
        ),
        body: Form(
            key: _JobCreateKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Job Posting Information',
                    ),
                  ],
                ),
                Text(
                  'Job Title',
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
                Text(
                  'Job Description',
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                Text(
                  'Soliciters Address',
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                Text(
                  'Contract Amount',
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                Text(
                  'Completion Duration',
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                Text(
                  'Contract Start Time',
                ),
                TextFormField(
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 209, 219, 210))),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_JobCreateKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      child: const Text(
                        "Submit Changes to Profile",
                        style: TextStyle(
                          color: Color.fromARGB(255, 33, 47, 243),
                        ),
                      )),
                ),
              ],
            )));
  }
}
