import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SessionStatus _session;
  late Uri _uri;

  // connector を作成する関数
  WalletConnect createConnector() {
    return WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
            name: 'create_to_Metamask_App',
            description: 'アプリの説明文です',
            url: 'https://yamawo.info',
            icons: [
              'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
            ]));
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ElevatedButton(
            onPressed: () => connectToMetamask(),
            child: const Text("Connect with Metamask"),
            style: ElevatedButton.styleFrom(
              onPrimary: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}