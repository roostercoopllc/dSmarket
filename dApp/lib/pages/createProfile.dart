import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class CreateProfilePage extends StatefulWidget {
  const CreateProfilePage({Key? key}) : super(key: key);

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _CreateProfileKey = GlobalKey<FormState>();

  var contractAddress,
      profileAliasStr,
      firstnameStr,
      lastnameStr,
      contactTypeEnum,
      contactValueStr;

  var contactTypeOptions = ['PHONE', 'EMAIL', 'IPFS', 'SOCIAL', 'OTHER'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _CreateProfileKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Profile Alias',
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
                      'First Name',
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
                      'Last Name',
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
                      'Contact Type',
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
                      'Contact Value',
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 209, 219, 210))),
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_CreateProfileKey.currentState!.validate()) {
                                // If the form is valid, display a snackbar. In the real world,
                                // you'd often call a server or save the information in a database.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')),
                                );
                              }
                            },
                            child: const Text(
                              "Submit Changes to Profile",
                              style: TextStyle(
                                color: Color.fromARGB(255, 33, 47, 243),
                              ),
                            ))),
                  ],
                ))));
  }
}
