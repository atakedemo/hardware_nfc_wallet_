import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SessionStatus _session;
  late Uri _uri;
  num _balance = 0;

  // connector を作成する関数
  WalletConnect createConnector() {
    return WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'create_to_Metamask_App',
        description: 'アプリの説明文です',
        url: 'https://bamb00.info',
        icons: [
          'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ]
      )
    );
  }

  void getBalance(String address) async {
    var apiUrl = "https://eth-mainnet.g.alchemy.com/v2/r6zSubRCOAPzLimDRt_R0MzIOx7EVsEm";
    var httpClient = new Client();
    var ethClient = new Web3Client(apiUrl, httpClient);

    EthereumAddress addr = EthereumAddress.fromHex(address);
    EtherAmount balance = await ethClient.getBalance(addr);
    print(addr);
    print(balance);
    _balance = await balance.getValueInUnit(EtherUnit.ether);
  }

  // ボタンが押された際に発火させる、walletConnect との session を確立する関数
  Future<void> connectToMetamask() async {
    final connector = createConnector();

    // session が確立されていない時
    if (!connector.connected) {
      try {
        final session =
          await connector.createSession(onDisplayUri: (uri) async {
          _uri = Uri.parse(uri);
          // Metamask アプリを立ち上げる
          await launchUrl(Uri.parse(uri));
        });

        setState(() {
          _session = session;
        });
      } catch (e) {
        print(e);
      }
    } else {
      // sessionに対して処理を設置する
      connector.on('connect', (session) => print(session));
      connector.on('session_update', (payload) => print(payload));
      connector.on('disconnect', (session) => print(session));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('アカウント設定'),
      ),
      body: Column(children: [
        Center(
          child: SingleChildScrollView(
            child: ElevatedButton(
              onPressed: () => connectToMetamask(),
              child: const Text("メタマスクと連携する"),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
              ),
            ),
          ),
        ),
        Text('残高を取得する'),
        Center(
          child: SingleChildScrollView(
            child: ElevatedButton(
              onPressed: () => getBalance("0xd8da6bf26964af9d7eed9e03e53415d37aa96045"),
              child: const Text("ETH残高を取得する"),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
              ),
            ),
          ),
        ),
        Text('ETH 残高：'),
        Text(
          '$_balance',
          style: Theme.of(context).textTheme.headline4,
        ),
      ])
      
    );
  }
}