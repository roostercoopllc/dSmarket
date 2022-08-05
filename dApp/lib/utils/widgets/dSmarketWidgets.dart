import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:d_smarket/pages/profiles/profile.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

import 'package:d_smarket/utils/helpers/dSmarketFunctions.dart';
import 'package:d_smarket/pages/dSmarketPages.dart';
import 'dart:math';

class JobViewCard extends StatelessWidget {
  const JobViewCard(
      {Key? key,
      this.jobAddress = '',
      this.jobTitle = 'Default Job Title',
      this.jobDescription = 'Default Job Description',
      this.salary = 'Default Salary',
      this.negotiationAddress = 'Default Negotiation Address'})
      : super(key: key);
  final String jobTitle;
  final String jobDescription;
  final String salary;
  final String negotiationAddress;
  final String jobAddress;

  getRandomIcon() {
    int random = Random().nextInt(10);
    List<Icon> icons = [
      const Icon(CommunityMaterialIcons.crystal_ball),
      const Icon(CommunityMaterialIcons.allergy),
      const Icon(CommunityMaterialIcons.wordpress),
      const Icon(CommunityMaterialIcons.face_agent),
      const Icon(CommunityMaterialIcons.account_heart),
      const Icon(CommunityMaterialIcons.lightbulb),
      const Icon(CommunityMaterialIcons.contactless_payment),
      const Icon(CommunityMaterialIcons.earth),
      const Icon(CommunityMaterialIcons.warehouse),
      const Icon(CommunityMaterialIcons.leaf)
    ];
    return icons[random];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: getRandomIcon(),
            title: Text(jobTitle),
            subtitle: Text(jobDescription),
            trailing: IconButton(
                onPressed: () {
                  print('Get QR Code');
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          FullJobView(jobAddress: jobAddress)));
                },
                icon: const Icon(CommunityMaterialIcons.crystal_ball)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Icon(CommunityMaterialIcons.ethereum),
            Text('Salary: ${salary} wei'),
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

  getWalletURL() {}
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
                  data:
                      'https://mumbai.polygonscan.com/address/${walletAddress}',
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

class CryptoExchangeCard extends StatelessWidget {
  const CryptoExchangeCard({
    Key? key,
    this.name = 'Rando Crypto Exchange',
    this.url = 'https://www.random.com',
    this.logo = 'assets/images/rooster_coop_logo.png',
  });
  final String name;
  final String url;
  final String logo;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ListTile(
          leading: Image.asset(logo),
          title: Text(name),
          subtitle: Text(url),
        ),
        IconButton(
            splashRadius: 100,
            iconSize: 200,
            icon: Ink.image(
              image: NetworkImage(logo),
            ),
            onPressed: () {
              // do something when the button is pressed
              debugPrint('Hi there');
            }),
      ],
    ));
  }
}

// I will need to kill this at some point.
class DebugWidget extends StatefulWidget {
  const DebugWidget({Key? key}) : super(key: key);
  @override
  _DebugWidgetState createState() => _DebugWidgetState();
}

class _DebugWidgetState extends State<DebugWidget> {
  final _CheaterKey = GlobalKey<FormState>();
  final _DebugContractKey = GlobalKey<FormState>();
  var storageValues = LocalStorage('d_smarket_local_storage.json');
  final _debugController = TextEditingController();
  final _cheaterController = TextEditingController();

  static Client httpClient = Client(); // = Client(http.IOClient());
  Web3Client ethereumClient =
      Web3Client(polygonClientUrl, httpClient); // Ethereum client
  // final sender = Address.fromAlgorandAddress(address: session.accounts[0]);

  // this is broke var walletProvider = EthereumWalletConnectProvider(widget.connector);

  printTheStore() {
    print('DebugWidget State');
    /*
    print('Storage: ${storageValues.getItem('walletAddress').toString()}');
    print('Profile: ${storageValues.getItem('profileAddress').toString()}');
    print('Contracts: ${storageValues.getItem('contracts').toString()}');
    print(
        'Negotiations: ${storageValues.getItem('myNegotiations').toString()}');
    print('Jobs: ${storageValues.getItem('myJobs').toString()}');
    print('JobReviews: ${storageValues.getItem('profileAddress').toString()}');
    // checkProfileContract();
    */
    getCurrentActivity();
  }

  checkContract() async {
    DeployedContract deployed =
        await getContractFromStorage(storageValues, 'd_smarketProfile');
    deployed.abi.functions.forEach((element) => {
          print('Contract: ${element.name}, Params: ${element.parameters}'),
          print('')
        });
    // print('Deployed Contract: ${deployed.abi.functions}');
  }

  checkProfileContract() async {
    //try {
    print('Query Contract');
    var profileContract = await queryFromStorage(
        ethereumClient, storageValues, 'd_smarketProfile', 'profileAlias', []);
    print('Query completed');
    print(profileContract);
    //} catch (e) {
    //  print('Error: ${e.toString()}');
    //}
  }

  getContractInformation(var contractNameParam) async {
    DeployedContract deployed =
        await getContractFromStorage(storageValues, contractNameParam);
    deployed.abi.functions.forEach((element) => {
          print('Contract: ${element.name}, Params: ${element.parameters}'),
          // print('')
        });
  }

  getCurrentActivity() async {
    // var retJobList = [];
    var demoJobs = storageValues.getItem('demoJobs');
    // print(demoJobs);
    demoJobs.forEach((value) async {
      print(value);
      Map<String, String> demoJobMap = await getJob(ethereumClient, value);
      print(demoJobMap);
      // retJobList.add(value);
    });
  }
  // return retJobList;

  doCannedTransaction() async {
    print('Doing Canned Transaction');
    var result = await transactionFromStorage(
        ethereumClient, storageValues, 'd_smarketCreatorUtil', 'createNewJob', [
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
                onPressed: printTheStore, child: Text('LocalStorage')),
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
                        // getContractInformation(_debugController.text);
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
