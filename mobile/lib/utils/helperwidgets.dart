import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gigme/pages/profile.dart';

class JobViewCard extends StatelessWidget {
  const JobViewCard({
    Key? key,
    this.jobTitle = 'Default Job Title',
    this.jobDescription = 'Default Job Description',
  }) : super(key: key);
  final String jobTitle;
  final String jobDescription;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.album),
            title: Text(jobTitle),
            subtitle: Text(jobDescription),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Negotiate'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Remove'),
                onPressed: () {/* ... */},
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

class QrProfileCard extends StatelessWidget {
  const QrProfileCard(
      {Key? key,
      this.walletAddress = 'This is a fake wallet address',
      this.accountLogo = 'assets/images/rooster_coop_logo.png',
      this.displayAccount = '0x123...456',
      this.networkName = 'Unknown Network',
      this.accountBalance = 0
      // this.profileAlias = 'Default Profile Alias',
      // this.profileDescription = 'Default Profile Description',
      // this.profileImage = 'Default Profile Image',
      })
      : super(key: key);
  final String walletAddress;
  final String accountLogo;
  final String displayAccount;
  final String networkName;
  final int accountBalance;
  // final String profileAlias;
  // final String profileDescription;
  // final String profileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Account Info'), actions: []),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        accountLogo,
                        height: 100,
                        width: 100,
                      ),
                    ],
                  ),
                  Column(children: [
                    Text(
                      displayAccount,
                      // '${_session.accounts[0].substring(0, 6)}...${_session.accounts[0].substring(_session.accounts[0].length - 4)}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      networkName,
                      // '${getNetworkName(_session.chainId)}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'Account Balance: ${accountBalance.toString()}',
                    ),
                  ]),
                ],
              ),
              /*
                Current Activity
              */
              Card(
                  child:
                      Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                /*
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(profileAlias),
                  subtitle: Text(profileDescription),
                ),
                */
                QrImage(
                  data: walletAddress,
                  backgroundColor: Colors.white,
                  // gapless: false,
                  // version: QrVersions.auto,
                  size: 200.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Edit'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ProfilePage()));
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('Remove'),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ]))
            ])));
  }
}
