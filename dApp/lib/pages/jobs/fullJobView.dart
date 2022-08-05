import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class FullJobView extends StatelessWidget {
  FullJobView({
    this.jobAddress = '',
    Key? key,
  }) : super(key: key);
  final String jobAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Job Details'),
        ),
        body: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          QrImage(
            data: 'https://mumbai.polygonscan.com/address/${jobAddress}',
            backgroundColor: Colors.white,
            // gapless: false,
            // version: QrVersions.auto,
            size: 200.0,
          ),
        ])));
  }
}
