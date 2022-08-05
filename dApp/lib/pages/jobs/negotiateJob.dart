import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

class NegotiateJobPage extends StatefulWidget {
  const NegotiateJobPage({Key? key}) : super(key: key);

  @override
  State<NegotiateJobPage> createState() => _NegotiateJobState();
}

class _NegotiateJobState extends State<NegotiateJobPage> {
  final _NegotiationKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _paymentInWei = TextEditingController();
  final _duration = TextEditingController();
  final LocalStorage storage = new LocalStorage('d_smarket_local_storage.json');
  var jobAddress = '';

  var paymentType = 'MATIC';
  getPaymentTypeInt() {
    if (paymentType == 'MATIC') {
      return 0;
    } else if (paymentType == 'LINK') {
      return 1;
    } else {
      return 2;
    }
  }

  getAvailableNegotiations() {
    return storage.getItem('negotiations');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Negotiate Jobs'),
        ),
        body: Form(
            key: _NegotiationKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Negotiate Jobs',
                    ),
                  ],
                ),
                DropdownButton(
                    items: <String>[
                      '0xD7ed8f5677F8c37AaFEC3D25DD1bD47d3d108c6f',
                      '0x0A632638e9AdE4e2d0b394982AC0Bb97fA22de81',
                      '0xe8112638595e26721d6a37599F98AE4b2377cb87'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        paymentType = value.toString();
                      });
                    }),
                TextFormField(
                  controller: _description,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.title),
                    hintText: 'Enter Desired Job Description',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                DropdownButton(
                    items: <String>['MATIC', 'LINK', 'ETH']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(paymentType),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        paymentType = value.toString();
                      });
                    }),
                TextFormField(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: _paymentInWei,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.access_time),
                    hintText: 'Contract Value in Wei',
                  ),

                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter in numbers';
                    }
                    return null;
                  },
                ),
                TextField(
                    controller: _duration,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today), //icon of text field
                        labelText: "Enter Date" //label text of field
                        ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _duration.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_NegotiationKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            )));
  }
}
