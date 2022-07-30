import 'package:flutter/material.dart';
import 'package:gigme/utils/helperfunctions.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({Key? key}) : super(key: key);

  @override
  State<CreateJobPage> createState() => _CreateJobState();
}

class _CreateJobState extends State<CreateJobPage> {
  final _JobCreateKey = GlobalKey<FormState>();

  final _jobTitle = TextEditingController();
  final _jobDescription = TextEditingController();
  final _jobSalary = TextEditingController();
  final _jobStarttime = TextEditingController();
  final _jobDuration = TextEditingController();

  final LocalStorage jstorage = new LocalStorage('gigme_local_storage.json');
  static Client httpClient = Client(); // = Client(http.IOClient());
  Web3Client ethereumClient = Web3Client(polygonClientUrl, httpClient);

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
                Row(mainAxisAlignment: MainAxisAlignment.center, children: []),
                TextFormField(
                  controller: _jobTitle,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Enter Job Title',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _jobDescription,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.description),
                    hintText: 'Enter Job Description',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _jobSalary,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    hintText: 'Enter Job Salary',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _jobStarttime,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time),
                    hintText: 'Enter Job Start Time',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter somemore text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _jobDuration,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time),
                    hintText: 'Enter Job Duration',
                  ),
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
                              Color.fromARGB(255, 57, 212, 65))),
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_JobCreateKey.currentState!.validate()) {
                          // If the form is valid, display a snackbar. In the real world,
                          // you'd often call a server or save the information in a database.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Posting Job...')),
                          );
                        }
                        var jobTx = await createJob(
                            ethereumClient,
                            jstorage,
                            _jobTitle.text,
                            _jobDescription.text,
                            BigInt.parse(_jobSalary.text),
                            BigInt.parse(_jobStarttime.text),
                            BigInt.parse(_jobDuration.text));
                        var holder = jstorage.getItem('pendingJobs');
                        holder.add(jobTx);
                        jstorage.setItem('pendingJobs', holder);
                      },
                      child: const Text(
                        "Create Job Posting",
                        style: TextStyle(
                          color: Color.fromARGB(255, 33, 47, 243),
                        ),
                      )),
                ),
              ],
            )));
  }
}
