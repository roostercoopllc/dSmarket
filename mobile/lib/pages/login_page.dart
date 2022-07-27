import 'package:flutter/material.dart';
import 'package:gigme/pages/searchJob.dart';
import 'package:gigme/pages/negotiateJob.dart';
import 'package:gigme/pages/createJob.dart';
import 'package:gigme/utils/helperfunctions.dart';
import 'package:gigme/utils/helperwidgets.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:localstorage/localstorage.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // For device coordination
  final LocalStorage storage = new LocalStorage('gigme_local_storage.json');
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

  var _session, _uri, _signature;

  List<dynamic> currentActivity = [];
  List<dynamic> marketHighlights = [];
  List<dynamic> recommendations = [];

  getCurrentActivity() {
    var holder = [];
    // var demoJobs = storage.getItem('demoJobs');
    transactionFromStorage(ethereumClient, storage, 'GigMeMarketPlace',
        'totalAvailableJobs', []).then((jobLen) {
          int jobLenInt = int.parse(jobLen);
      Future.wait([
        getJobFromMarket(ethereumClient, storage, jobLenInt - 1)
      ]).then((jobAddresses) => {
        jobAddresses.forEach((address) {
      // print(value);
      getJob(ethereumClient, address.toString()).then((value) => {
            print('This is returning $value'),
            holder.add(value),
            print(holder),
            setState(() {
              currentActivity = holder;
            })
          });
        }
    });
    
    });
  }

  getMarketHighlights() async {
    var holder = [];
    var demoJobs = storage.getItem('demoJobs');
    demoJobs.forEach((value) {
      // print(value);
      getJob(ethereumClient, value).then((value) => {
            print('This is returning $value'),
            holder.add(value),
            print(holder),
            setState(() {
              marketHighlights = holder;
            })
          });
    });
  }

  getRecommendations() {
    var holder = [];
    var demoJobs = storage.getItem('demoJobs');
    demoJobs.forEach((value) {
      // print(value);
      getJob(ethereumClient, value).then((value) => {
            print('This is returning $value'),
            holder.add(value),
            print(holder),
            setState(() {
              recommendations = holder;
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
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              print('Session Updated');
              print(_session.toString());
              // print(_session.accounts[0]);
              // print(_session.chainId);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    var account_logo = 'assets/images/rooster_coop_logo.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('GigMe Home'),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Activity',
                      style: TextStyle(fontSize: 20),
                    ),
                    IconButton(
                        onPressed: getCurrentActivity,
                        icon: Icon(Icons.refresh_outlined))
                  ],
                ),
                for (var i in currentActivity)
                  JobViewCard(
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
