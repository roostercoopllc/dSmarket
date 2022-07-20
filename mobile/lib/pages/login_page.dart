import 'package:flutter/material.dart';
import 'package:mobile/pages/profile.dart';
import 'package:mobile/pages/searchJob.dart';
import 'package:mobile/pages/negotiateJob.dart';
import 'package:mobile/pages/createJob.dart';
import 'package:mobile/utils/helperfunctions.dart';
import 'package:mobile/utils/helperwidgets.dart';
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

    List<int> marketHighlights = [1, 2, 3];
    List<int> historyHighlights = [1, 2, 3];
    List<Map<String, dynamic>> recommendationHighlights = [
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
      ),
      body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        (_session != null)
            ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          account_logo,
                          height: 100,
                          width: 100,
                        ),
                      ],
                    ),
                    Column(children: [
                      Text(
                        '${_session.accounts[0].substring(0, 6)}...${_session.accounts[0].substring(_session.accounts[0].length - 4)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        '${getNetworkName(_session.chainId)}',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        'Account Balance: \$100',
                      ),
                    ]),
                  ],
                ),
                Text(
                  'Job History and Updates',
                  style: TextStyle(fontSize: 20),
                ),
                for (var i in marketHighlights) JobViewCard(),
                Text(
                  'Job Market Highlights',
                  style: TextStyle(fontSize: 20),
                ),
                for (var i in historyHighlights) JobViewCard(),
                Text(
                  'Job Recommendations',
                  style: TextStyle(fontSize: 20),
                ),
                for (var i in marketHighlights) JobViewCard(),
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
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfilePage()));
                    },
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
