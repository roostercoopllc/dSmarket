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
  var contactTypeOptions = ['PHONE', 'EMAIL', 'IPFS', 'SOCIAL', 'OTHER'];

  editFields(BuildContext context) {
    setState(() {
      print(context);
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Job History and Updates',
                      ),
                      Switch.adaptive(
                          value: editing, onChanged: editFields(context)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Profile Alias',
                          ),
                          Text(
                            'First Name',
                          ),
                          Text(
                            'Last Name',
                          ),
                          Text(
                            'Contact Type',
                          ),
                          Text(
                            'Contact Value',
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
