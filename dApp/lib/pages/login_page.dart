import 'package:flutter/material.dart';
import 'package:d_smarket/pages/searchJob.dart';
import 'package:d_smarket/pages/negotiateJob.dart';
import 'package:d_smarket/pages/createJob.dart';
import 'package:d_smarket/utils/helperfunctions.dart';
import 'package:d_smarket/utils/helperwidgets.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:localstorage/localstorage.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'dart:math';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // For device coordination
  final LocalStorage storage = new LocalStorage('d_smarket_local_storage.json');
  static Client httpClient = Client(); // = Client(http.IOClient());
  Web3Client ethereumClient =
      Web3Client(polygonClientUrl, httpClient); // Ethereum client
  // For walletconnect
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'My App',
          description: 'An app for converting pictures to NFT',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  var _session, _uri, _signature, balance, pendingTransactions;
  int totalJobs = 4;

  // This is the cheaterstuff to remove
  final _cheaterController = TextEditingController();
  final _CheaterKey = GlobalKey<FormState>();
  bool _cheater = false;

  List<dynamic> currentActivity = [];
  List<dynamic> marketHighlights = [];
  List<dynamic> recommendations = [];

  getBalance() async {
    // You can now call rpc methods. This one will query the amount of Ether you own
    var credentials =
        EthPrivateKey.fromHex(storage.getItem('cheaterPrivateKey'));
    EtherAmount liveBalance =
        await ethereumClient.getBalance(credentials.address);
    print(liveBalance.getValueInUnit(EtherUnit.ether));
    setState(() {
      balance = liveBalance.getValueInUnit(EtherUnit.ether).toStringAsFixed(3);
    });
  }

  getPendingTransactions() async {
    setState(() {
      var pT = storage.getItem('pendingJobs');
      pendingTransactions = pT.length;
    });
  }

  getTotalJobs() async {
    queryFromStorage(
            ethereumClient, storage, 'dSmarketPlace', 'totalAvailableJobs', [])
        .then((jobLen) {
      print('Job Length: $jobLen');
      int jobLenInt = int.parse(jobLen[0].toString());
      setState(() {
        totalJobs = jobLenInt;
      });
    }).catchError((e) {
      print(e);
    });
  }

  getCurrentActivity() async {
    var jobAddressList = [];
    getPendingTransactions();
    getJobFromMarket(ethereumClient, storage, totalJobs - 1).then((jobOne) => {
          jobAddressList.add(jobOne),
          getJobFromMarket(ethereumClient, storage, totalJobs - 2)
              .then((jobTwo) => {
                    jobAddressList.add(jobTwo),
                    getJobFromMarket(ethereumClient, storage, totalJobs - 3)
                        .then((jobThree) => {jobAddressList.add(jobThree)})
                        .then((output) => {
                              setState(() {
                                currentActivity = jobAddressList;
                              })
                            })
                  })
        });
  }

  getMarketHighlights() async {
    var jobAddressList = [];
    getTotalJobs().then((jobs) {
      int randomJob = Random().nextInt(totalJobs);
      getJobFromMarket(ethereumClient, storage, randomJob).then((jobOne) => {
            randomJob = Random().nextInt(totalJobs),
            jobAddressList.add(jobOne),
            getJobFromMarket(ethereumClient, storage, randomJob)
                .then((jobTwo) => {
                      randomJob = Random().nextInt(totalJobs),
                      jobAddressList.add(jobTwo),
                      getJobFromMarket(ethereumClient, storage, randomJob)
                          .then((jobThree) => {
                                randomJob = Random().nextInt(totalJobs),
                                jobAddressList.add(jobThree)
                              })
                          .then((output) => {
                                setState(() {
                                  marketHighlights = jobAddressList;
                                })
                              })
                    })
          });
    });
  }

  getRecommendations() async {
    var jobAddressList = [];
    getTotalJobs().then((jobs) {
      int randomJob = Random().nextInt(totalJobs);
      getJobFromMarket(ethereumClient, storage, randomJob).then((jobOne) => {
            randomJob = Random().nextInt(totalJobs),
            jobAddressList.add(jobOne),
            getJobFromMarket(ethereumClient, storage, randomJob)
                .then((jobTwo) => {
                      randomJob = Random().nextInt(totalJobs),
                      jobAddressList.add(jobTwo),
                      getJobFromMarket(ethereumClient, storage, randomJob)
                          .then((jobThree) => {
                                randomJob = Random().nextInt(totalJobs),
                                jobAddressList.add(jobThree)
                              })
                          .then((output) => {
                                setState(() {
                                  recommendations = jobAddressList;
                                })
                              })
                    })
          });
    });
  }

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        // print(session.accounts[0]);
        // print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }

  logoutUsingMetamask(BuildContext context) async {
    setState(() {
      _session = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    connector.on(
        'connect',
        (session) => setState(
              () {
                print('Connected');
                _session = _session;
                startLocalStorage(storage);
                storage.setItem("walletAddress", _session.accounts[0]);
                getCurrentActivity();
                getMarketHighlights();
                getRecommendations();
                getBalance();
                getPendingTransactions();
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              print('Session Updated');
              print(_session.toString());
              getCurrentActivity();
              getMarketHighlights();
              getRecommendations();
              getBalance();
              getPendingTransactions();
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    var account_logo = 'assets/images/rooster_coop_logo.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('dSmarket Home'),
        actions: (_session != null)
            ? <Widget>[
                IconButton(
                  icon: Icon(CommunityMaterialIcons.android_debug_bridge),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => DebugWidget()));
                  },
                ),
                IconButton(
                  icon: Icon(CommunityMaterialIcons.card_account_details_star),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QrProfileCard(
                              walletAddress: _session.accounts[0],
                              accountLogo:
                                  'assets/images/rooster_coop_logo.png',
                              displayAccount:
                                  '${_session.accounts[0].substring(0, 6)}...${_session.accounts[0].substring(_session.accounts[0].length - 4)}',
                              networkName: getNetworkName(_session.chainId),
                              accountBalance: 100,
                            )));
                  },
                )
              ]
            : <Widget>[Container()],
      ),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        (_session != null)
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Pending Transactions: $pendingTransactions'),
                    Spacer(),
                    Text('Balance of Wallet: $balance'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recently added jobs',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                        onPressed: getCurrentActivity,
                        icon: Icon(Icons.refresh_outlined))
                  ],
                ),
                for (var i in currentActivity)
                  JobViewCard(
                    jobAddress: i['jobAddress'].toString(),
                    jobTitle: i['title'].toString(),
                    jobDescription: i['description'].toString(),
                    salary: i['salary'].toString(),
                    // jobTypeIcon: getIconForJobType(i['jobTypeIcon']),
                  ),

                /*
                  Market Highlights
                */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Market Highlights',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                        onPressed: getMarketHighlights,
                        icon: Icon(Icons.refresh_outlined))
                  ],
                ),
                for (var i in marketHighlights)
                  JobViewCard(
                    jobTitle: i['title'].toString(),
                    jobDescription: i['description'].toString(),
                    salary: i['salary'].toString(),
                    // jobTypeIcon: getIconForJobType(i['jobTypeIcon']),
                  ),
                /*
                  Job Recommendations
                */
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Job Recommendations',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                        onPressed: getRecommendations,
                        icon: Icon(Icons.refresh_outlined))
                  ],
                ),
                for (var i in recommendations)
                  JobViewCard(
                    jobTitle: i['title'].toString(),
                    jobDescription: i['description'].toString(),
                    salary: i['salary'].toString(),
                    // jobTypeIcon: getIconForJobType(i['jobTypeIcon']),
                  ),
              ])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(
                  'assets/images/rooster_coop_logo.png',
                  fit: BoxFit.fitHeight,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 57, 212, 65))),
                    onPressed: () => loginUsingMetamask(context),
                    child: const Text(
                      "Connect with Metamask App",
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 47, 243),
                      ),
                    )),
                (!_cheater)
                    ? Form(
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
                                if (_cheaterController != null) {
                                  setState(() {
                                    _cheater = true;
                                  });
                                  storage.setItem('cheaterPrivateKey',
                                      _cheaterController.text);
                                }
                              }),
                        ]))
                    : Container()
                /* ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 57, 212, 65))),
                    onPressed: () => loginUsingMetamask(context),
                    child: const Text(
                      "Create a Profile",
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 47, 243),
                      ),
                    )), */
              ]),
      ])),
      drawer: (_session != null)
          ? Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                    ),
                    child: Image(
                        image:
                            AssetImage('assets/images/rooster_coop_logo.png')),
                  ),
                  ListTile(
                    title: const Text('Create Jobs'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CreateJobPage()));
                    },
                  ),
                  ListTile(
                    title: const Text('Search Jobs'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SearchJobPage()));
                    },
                  ),
                  ListTile(
                    title: const Text('Negotiate Jobs'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const NegotiateJobPage()));
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      logoutUsingMetamask(context);
                    },
                  ),
                ],
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text('Please Connect with MetaMask First')],
            ),
    );
  }
}
