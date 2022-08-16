import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';

class NegotiateJobDemoPage extends StatefulWidget {
  const NegotiateJobDemoPage({Key? key}) : super(key: key);

  @override
  State<NegotiateJobDemoPage> createState() => _NegotiateJobDemoState();
}

class _NegotiateJobDemoState extends State<NegotiateJobDemoPage> {
  final _NegotiationKey = GlobalKey<FormState>();
  final _description = TextEditingController();
  final _paymentInWei = TextEditingController();
  final _duration = TextEditingController();
  final LocalStorage storage = new LocalStorage('d_smarket_local_storage.json');
  var jobAddress = '';

  var paymentType = 'MATIC';

  getPaymentTypeInt() {
    if (paymentType == 'MATIC') {
      return new BigInt.from(0);
    } else if (paymentType == 'LINK') {
      return new BigInt.from(1);
    } else {
      return new BigInt.from(2);
    }
  }

  var negotationRecords = [
    {
      'description':
          'I created this cool new application. I need someone to test it. It is obviously perfect, this is just to make the VC money going into it happy',
      'paymentInWei': '1598753',
      'duration': '321123',
      'paymentType': 'MATIC',
      "author": 'solicitor',
    },
    {
      'description':
          'Contractor will work for 30 hours over the course of 4 weeks to fully implement testing of the application.',
      'paymentInWei': '2598753',
      'duration': '321123',
      'paymentType': 'MATIC',
      "author": 'contractor',
    },
    {
      'description':
          'Contractor will work for 50 hours over the course of 4 weeks to fully implement testing of the application.',
      'paymentInWei': '2598753',
      'duration': '321123',
      'paymentType': 'MATIC',
      "author": 'solicitor',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Negotiate Jobs'),
        ),
        body: SingleChildScrollView(
            key: _NegotiationKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [],
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
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    value: paymentType,
                    icon: const Icon(Icons.arrow_downward),
                    style: TextStyle(color: Color.fromARGB(255, 58, 107, 148)),
                    onChanged: (value) {
                      print(value.toString());
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
                        negotationRecords.add({
                          'description': _description.text,
                          'paymentInWei': _paymentInWei.text,
                          'duration': _duration.text,
                          'paymentType': paymentType,
                          'author': 'contractor',
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
                Text('Mobile App Testing'),
                SizedBox(
                  height: 15,
                ),
                for (var record in negotationRecords)
                  Column(
                      mainAxisAlignment: (record['author'] == 'solicitor')
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Text("Description ${record['description'].toString()}"
                            .toString()),
                        Text("Duration ${record['duration'].toString()}"),
                        Text("Payment ${record['paymentInWei'].toString()}"),
                        Text(
                            "Payment Token: ${record['paymentType'].toString()}"),
                        SizedBox(
                          height: 15,
                        ),
                      ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => {print('Pressed')},
                      child: Text('Accept'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 57, 212, 65))),
                    ),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () => {print('Pressed')},
                        child: Text('Withdraw'),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 221, 41, 41)))),
                    Spacer(),
                  ],
                ),
              ],
            )));
  }
}
