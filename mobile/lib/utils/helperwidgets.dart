import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gigme/pages/profile.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import 'package:gigme/utils/helperfunctions.dart';
import 'package:gigme/pages/negotiateJob.dart';

class JobViewCard extends StatelessWidget {
  const JobViewCard(
      {Key? key,
      this.jobTitle = 'Default Job Title',
      this.jobDescription = 'Default Job Description',
      this.salary = 'Default Salary',
      this.negotiationAddress = 'Default Negotiation Address',
      this.jobTypeIcon = const Icon(CommunityMaterialIcons.crystal_ball)})
      : super(key: key);
  final String jobTitle;
  final String jobDescription;
  final String salary;
  final String negotiationAddress;
  final Icon jobTypeIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            // leading: jobTypeIcon,
            title: Text(jobTitle),
            subtitle: Text(jobDescription),
            trailing: jobTypeIcon,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(CommunityMaterialIcons.ethereum),
            Text('Salary: ${salary}'),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              TextButton(
                child: const Text('Negotiate'),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NegotiateJobPage()));
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
                    /*
                    TextButton(
                      child: const Text('Remove'),
                      onPressed: () {/* ... */},
                    ),
                    const SizedBox(width: 8),
                    */
                  ],
                ),
              ]))
            ])));
  }
}

Icon getIconForJobType(String jobType) {
  switch (jobType) {
    case 'SERVICE':
      return Icon(CommunityMaterialIcons.hammer_wrench);
    case 'LABOR':
      return Icon(CommunityMaterialIcons.shovel);
    case 'TRANSPORT':
      return Icon(CommunityMaterialIcons.car_arrow_left);
    case 'OTHER':
      return Icon(CommunityMaterialIcons.crystal_ball);
    default:
      return Icon(CommunityMaterialIcons.ethereum);
  }
}

class DebugWidget extends StatefulWidget {
  const DebugWidget({Key? key}) : super(key: key);

  @override
  _DebugWidgetState createState() => _DebugWidgetState();
}

class _DebugWidgetState extends State<DebugWidget> {
  final _CheaterKey = GlobalKey<FormState>();
  final _DebugContractKey = GlobalKey<FormState>();
  var storageValues = LocalStorage('gigme_local_storage.json');
  final _debugController = TextEditingController();
  final _cheaterController = TextEditingController();

  static Client httpClient = Client(); // = Client(http.IOClient());
  Web3Client ethereumClient =
      Web3Client(polygonClientUrl, httpClient); // Ethereum client

  // final sender = Address.fromAlgorandAddress(address: session.accounts[0]);

  printTheState() {
    print('DebugWidget State');
    print('Storage: ${storageValues.getItem('walletAddress').toString()}');
    print('Profile: ${storageValues.getItem('profileAddress').toString()}');
  }

  checkContract() async {
    DeployedContract deployed =
        await getContract(storageValues, 'GigMeProfile');
    deployed.abi.functions.forEach((element) => {
          print('Contract: ${element.name}, Params: ${element.parameters}'),
          print('')
        });
    // print('Deployed Contract: ${deployed.abi.functions}');
  }

  checkProfileContract() async {
    //try {
    print('Query Contract');
    var profileContract = await query(
        ethereumClient, storageValues, 'GigMeProfile', 'profileAlias', []);
    print('Query completed');
    print(profileContract);
    //} catch (e) {
    //  print('Error: ${e.toString()}');
    //}
  }

  getContractInformation(var contractNameParam) async {
    DeployedContract deployed =
        await getContract(storageValues, contractNameParam);
    deployed.abi.functions.forEach((element) => {
          print('Contract: ${element.name}, Params: ${element.parameters}'),
          // print('')
        });
  }

  doCannedTransaction() async {
    print('Doing Canned Transaction');
    var result = await transaction(
        ethereumClient, storageValues, 'GigMeCreatorUtil', 'createNewJob', [
      'Updated Profile Alias',
      'Updated Name',
      'Updated Surname',
      'updatedcontact@email.com'
    ]);
    print('Transaction Result: ${result.toString()}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Debug Info'), actions: []),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            ElevatedButton(
                onPressed: printTheState, child: Text('LocalStorage')),
            /*
        ElevatedButton(onPressed: checkContract, child: Text('Get Contract')),
        ElevatedButton(
            onPressed: checkProfileContract,
            child: Text('Query Default Profile Contract')),
            */
            ElevatedButton(
                onPressed: () {
                  print(
                      'Private Key: ${storageValues.getItem('cheaterPrivateKey')}');
                },
                child: Text('Cheater Private Key Reveal')),
            Form(
                key: _CheaterKey,
                child: Column(children: [
                  TextFormField(
                    controller: _cheaterController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.contact_page),
                      hintText: "Straight string of Private Key",
                      labelText: "Cheater Private Key",
                    ),
                  ),
                  ElevatedButton(
                      child: Text('Set Cheater Private Key'),
                      onPressed: () {
                        print(
                            'This is pressed. With this value: ${_cheaterController.text}');
                        storageValues.setItem(
                            'cheaterPrivateKey', _cheaterController.text);
                      }),
                ])),
            Form(
                key: _DebugContractKey,
                child: Column(children: [
                  TextFormField(
                    controller: _debugController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.contact_page),
                      hintText: "Get Contract Information",
                      labelText: "Contract Name",
                    ),
                  ),
                  ElevatedButton(
                      child: Text('Print Contract Info'),
                      onPressed: () {
                        print(
                            'This is pressed. With this value: ${_debugController.text}');
                        getContractInformation(_debugController.text);
                      }),
                  ElevatedButton(
                      child: Text('Transact Info'),
                      onPressed: () {
                        //print(
                        //    'This is pressed. With this value: ${_debugController.text}');
                        //getContractInformation(_debugController.text);
                        doCannedTransaction();
                      }),
                ]))
          ])),
    );
  }
}
