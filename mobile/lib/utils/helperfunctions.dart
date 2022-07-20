import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

String truncateString(String text, int front, int end) {
  int size = front + end;

  if (text.length > size) {
    String finalString =
        "${text.substring(0, front)}...${text.substring(text.length - end)}";
    return finalString;
  }

  return text;
}

String generateSessionMessage(String accountAddress) {
  String message =
      'Hello $accountAddress, welcome to our app. By signing this message you agree to learn and have fun with blockchain';
  print(message);

  var hash = keccakUtf8(message);
  final hashString = '0x${bytesToHex(hash).toString()}';

  return hashString;
}

String getAccountBalance(String accountAddress) {
  String balance = '0';
  return balance;
}

Map<String, String> getNegotiations(String accountAddress) {
  return {};
}

Map<String, String> getJobs(String accountAddress) {
  return {};
}

Map<String, String> getJobReviews(String accountAddress) {
  return {};
}

String getNetworkName(int chainId) {
  switch (chainId) {
    case 1:
      return 'Ethereum Mainnet';
    case 3:
      return 'Ropsten Testnet';
    case 4:
      return 'Rinkeby Testnet';
    case 5:
      return 'Goreli Testnet';
    case 42:
      return 'Kovan Testnet';
    case 137:
      return 'Polygon Mainnet';
    case 80001:
      return 'Mumbai Testnet';
    default:
      return 'Unknown Chain';
  }
}

Future<String> signMessageWithMetamask(
  WalletConnect connector,
  String message,
  String uri,
  SessionStatus session,
) async {
  if (connector.connected) {
    try {
      print("Message received");
      print(message);

      EthereumWalletConnectProvider provider =
          EthereumWalletConnectProvider(connector);
      launchUrlString(uri, mode: LaunchMode.externalApplication);
      var signature = await provider.personalSign(
          message: message, address: session.accounts[0], password: "");
      // print(signature);
      return signature;
    } catch (exp) {
      // print("Error while signing transaction");
      print(exp);
      return "Error Occured" + exp.toString();
    }
    ;
  } else {
    // print("Not connected");
    return "Not connected";
  }
}

String devRpcUrl = "http://10.0.2.2:7545";
String devWsUrl = "ws://10.0.2.2:7545/";
String devPrivateKey = "Enter Private Key";
