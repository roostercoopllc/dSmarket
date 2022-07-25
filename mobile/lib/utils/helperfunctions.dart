import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

import 'package:walletconnect_dart/walletconnect_dart.dart';

import 'package:url_launcher/url_launcher_string.dart';

import 'package:localstorage/localstorage.dart';

import 'package:gigme/utils/helperfunctions.dart';

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

bool startLocalStorage(LocalStorage storage) {
  if (storage.getItem('initialized') == null) {
    storage.setItem('initialized', true);
    storage.setItem(
        'walletAddress', '0x0000000000000000000000000000000000000000');
    //storage.setItem(
    //    'profileAddress', '0x0c9Bf82F3dA04981a5648bA2674BEF973CFBf23d');
    storage.setItem('contracts', [
      {
        "contractName": "GigMeCreatorUtil",
        "contractAddress": "0xf9851ed7f6005226f770B5f43CF2BC8B471954D7"
      },
      {
        "contractName": "GigMeProfile",
        "contractAddress": "0x0c9Bf82F3dA04981a5648bA2674BEF973CFBf23d"
      },
      {
        "contractName": "GigMeJobAdvertisement",
        "contractAddress": "0xf9851ed7f6005226f770B5f43CF2BC8B471954D7"
      },
    ]);
    storage.setItem('myNegotiations', []);
    storage.setItem('myJobs', []);
    storage.setItem('myJobReviews', []);
  }
  return storage.getItem('initialized');
}

TextEditingController controller = TextEditingController();
String private_key = "";

String polygonClientUrl =
    'https://polygon-mumbai.infura.io/v3/a4377cb55c9340f5a731d51c05fc0f22';

Future<List<dynamic>> query(Web3Client ethereumClient, LocalStorage storage,
    String contractName, String functionName, List<dynamic> args) async {
  print('Ethereum Client: ${ethereumClient}');
  DeployedContract contract = await getContract(storage, contractName);
  print('Contract: ${contract.function(functionName)}');
  ContractFunction function = contract.function(functionName);
  print('Function: ${function.name}');
  print(ethereumClient);
  List<dynamic> result = await ethereumClient.call(
      contract: contract, function: function, params: args);
  print('Result: ${result}');
  return result;
}

Future<String> transaction(Web3Client ethereumClient, LocalStorage storage,
    String contractName, String functionName, List<dynamic> args) async {
  EthPrivateKey credential = EthPrivateKey.fromHex(private_key);
  DeployedContract contract = await getContract(storage, contractName);
  print(contract);
  ContractFunction function = contract.function(functionName);
  dynamic result = await ethereumClient.sendTransaction(
    credential,
    Transaction.callContract(
      contract: contract,
      function: function,
      parameters: args,
    ),
    fetchChainIdFromNetworkId: true,
    chainId: null,
  );

  return result;
}

Future<DeployedContract> getContract(
    LocalStorage storage, String abiName) async {
  String abiJson = await rootBundle.loadString("assets/abi/${abiName}.json");
  // print(abiJson);
  // String contractAddress = "0xd55B64d9b7816f2e2D9be07CbC52303A77B7163b";
  String contractAddress = getContractAddress(storage, abiName);
  print(contractAddress);
  DeployedContract contract = DeployedContract(
    ContractAbi.fromJson(abiJson, abiName),
    EthereumAddress.fromHex(contractAddress),
  );

  return contract;
}

String getContractAddress(LocalStorage storage, String abiFileName) {
  String contractAddress = 'Abi file not found';
  storage.getItem('contracts').forEach((element) {
    if (element['contractName'] == abiFileName) {
      contractAddress = element['contractAddress'].toString();
    }
  });
  return contractAddress;
}
