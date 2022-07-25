import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _ProfileKey = GlobalKey<FormState>();
  final _ProfileAliasController = TextEditingController();
  final _ProfileFirstnameController = TextEditingController();
  final _ProfileLastnameController = TextEditingController();\
  final _ProfileContactValueController = TextEditingController();
  // Profile Address
  final _ProfileAddressKey = GlobalKey<FormState>();
  final _ProfileAddressController = TextEditingController();
  final LocalStorage pstorage = new LocalStorage('gigme_local_storage.json');

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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              Form(
                  key: _ProfileAddressKey,
                  child: Column(children: [
                    TextFormField(
                      controller: _ProfileAddressController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.contact_page),
                        hintText: "Profile Address",
                        labelText: "Tx Address of Profile",
                      ),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 57, 212, 65))),
                        child: const Text(
                          'Save Profile Address',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 47, 243),
                          ),
                        ),
                        onPressed: () {
                          print(
                              'This is pressed. With this value: ${_ProfileAddressController.text}');
                          pstorage.setItem(
                              'profileAddress', _ProfileAddressController.text);
                        }),
                  ])),
              Form(
                  key: _ProfileKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _ProfileAliasController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          hintText: "Profile Alias",
                          labelText: "Profile Alias",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot remain blank';
                          }
                          return null;
                        },
                        // style: TextStyle(
                        //   color: Color.fromARGB(255, 255, 255, 255),
                        // ),
                      ),
                      // Text(
                      //   'First Name',
                      // ),
                      TextFormField(
                        controller: _ProfileFirstnameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.contact_page),
                          hintText: "First Name",
                          labelText: "First Name",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot remain blank';
                          }
                          return null;
                        },
                      ),
                      // Text(
                      //   'Last Name',
                      // ),
                      TextFormField(
                        controller: _ProfileLastnameController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.contact_page),
                          hintText: "Last Name",
                          labelText: "Last Name",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot remain blank';
                          }
                          return null;
                        },
                      ),
                      // Text(
                      //   'Contact Type',
                      // ),
                      TextFormField(
                        controller: _ProfileContactValueController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.contact_page),
                          hintText: "Contact Type",
                          labelText: "Contact Type",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot remain blank';
                          }
                          return null;
                        },
                      ),
                      // Text(
                      //   'Contact Value',
                      // ),
                      TextFormField(
                        decoration: const InputDecoration(
                          icon: Icon(Icons.contact_page),
                          hintText: "Contact Value",
                          labelText: "Contact Value",
                        ),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Field cannot remain blank';
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
                                          Color.fromARGB(255, 57, 212, 65))),
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_ProfileKey.currentState!.validate()) {
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
                              )))
                    ],
                  ))
            ])));
  }
}
