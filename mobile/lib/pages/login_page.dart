import 'package:flutter/material.dart';
import 'package:gigme/pages/searchJob.dart';
import 'package:gigme/pages/negotiateJob.dart';
import 'package:gigme/pages/createJob.dart';
import 'package:gigme/utils/helperfunctions.dart';
import 'package:gigme/utils/helperwidgets.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
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
                _session = _session;
              },
            ));
    connector.on(
        'session_update',
        (payload) => setState(() {
              _session = payload;
              // print(_session.accounts[0]);
              // print(_session.chainId);
            }));
    connector.on(
        'disconnect',
        (payload) => setState(() {
              _session = null;
            }));

    var account_logo = 'assets/images/rooster_coop_logo.png';

    List<Map<String, String>> currentActivity = [
      {
        'title': 'Totally Do This Job!',
        'decription': 'This is a description of the job',
        'status': 'Pending',
        'price': '\$100',
      },
      {
        'title': 'Totally Do This Job2!',
        'decription': 'This is a description of the job2',
        'status': 'Pending',
        'price': '\$200',
      },
      {
        'title': 'Totally Do This Job3!',
        'decription': 'This is a description of the job3',
        'status': 'Pending',
        'price': '\$300',
      }
    ];
    List<Map<String, String>> marketHighlights = [
      {
        'title': 'Totally Do This Job!',
        'decription': 'This is a description of the job',
        'status': 'Pending',
        'price': '\$100',
      },
      {
        'title': 'Totally Do This Job2!',
        'decription': 'This is a description of the job2',
        'status': 'Pending',
        'price': '\$200',
      },
      {
        'title': 'Totally Do This Job3!',
        'decription': 'This is a description of the job3',
        'status': 'Pending',
        'price': '\$300',
      }
    ];
    List<Map<String, String>> recommendationHighlights = [
      {
        'title': 'Totally Do This Job!',
        'decription': 'This is a description of the job',
        'status': 'Pending',
        'price': '\$100',
      },
      {
        'title': 'Totally Do This Job2!',
        'decription': 'This is a description of the job2',
        'status': 'Pending',
        'price': '\$200',
      },
      {
        'title': 'Totally Do This Job3!',
        'decription': 'This is a description of the job3',
        'status': 'Pending',
        'price': '\$300',
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('GigMe Home'),
        actions: (_session != null)
            ? <Widget>[
                IconButton(
                  icon: Icon(Icons.qr_code),
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
                Text(
                  'Current Activity',
                  style: TextStyle(fontSize: 20),
                ),
                for (var i in currentActivity)
                  JobViewCard(
                    jobTitle: i['title'].toString(),
                    jobDescription: i['decription'].toString(),
                  ),

                /*
                  Market Highlights
                */
                Text(
                  'Market Highlights',
                  style: TextStyle(fontSize: 20),
                ),
                for (var i in marketHighlights)
                  JobViewCard(
                    jobTitle: i['title'].toString(),
                    jobDescription: i['decription'].toString(),
                  ),
                /*
                  Job Recommendations
                */
                Text(
                  'Job Recommendations',
                  style: TextStyle(fontSize: 20),
                ),
                for (var i in recommendationHighlights)
                  JobViewCard(
                    jobTitle: i['title'].toString(),
                    jobDescription: i['decription'].toString(),
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
                            Color.fromARGB(255, 209, 219, 210))),
                    onPressed: () => loginUsingMetamask(context),
                    child: const Text(
                      "Connect with Metamask App",
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 47, 243),
                      ),
                    )),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 209, 219, 210))),
                    onPressed: () => loginUsingMetamask(context),
                    child: const Text(
                      "Create a Profile",
                      style: TextStyle(
                        color: Color.fromARGB(255, 33, 47, 243),
                      ),
                    )),
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
