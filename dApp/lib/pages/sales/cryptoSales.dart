import 'package:flutter/cupertino.dart';
import 'package:d_smarket/utils/widgets/dSmarketWidgets.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class CryptoSalesPage extends StatelessWidget {
  CryptoSalesPage({Key? key}) : super(key: key);
  var _storage = LocalStorage('d_smarket_local_storage.json');

  getExchanges() {
    return _storage.getItem('exchanges');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Partner Exchanges'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var exchange in getExchanges())
              CryptoExchangeCard(
                name: exchange['name'],
                url: exchange['url'],
                logo: exchange['logo'],
              ),
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
