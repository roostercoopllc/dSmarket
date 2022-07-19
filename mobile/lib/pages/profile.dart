import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // The Profile Page vars
  // The Profile Contract vars
  var editing = false;

  var profileAliasStr,
      firstnameStr,
      lastnameStr,
      contactTypeEnum,
      contactValueStr;
  var contactTypeOptions = {
    'PHONE': 1,
    'EMAIL': 2,
    'IPFS': 3,
    'SOCIAL': 4,
    'OTHER': 5
  };

  editFields(BuildContext context) {
    setState(() {
      editing = !editing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'Profile Page',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
