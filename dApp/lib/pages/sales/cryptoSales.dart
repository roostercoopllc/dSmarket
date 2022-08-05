import 'package:flutter/cupertino.dart';
import 'package:d_smarket/utils/widgets/dSmarketWidgets.dart';
import 'package:localstorage/localstorage.dart';

class CryptoSalesPage extends StatelessWidget {
  CryptoSalesPage({Key? key}) : super(key: key);
  LocalStorage _storage = LocalStorage('d_smarket_local_storage.json');

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Crypto Sales'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Crypto Sales',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 20),
            Text(
              'Coming soon',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            CupertinoButton(
              child: Text('Back'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
