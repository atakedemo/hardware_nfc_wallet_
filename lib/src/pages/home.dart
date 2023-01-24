import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void readNFC() async {
    print('Home is here');
    await NfcManager.instance.startSession(
      alertMessage: "ICカードをかざしてください",
      onDiscovered: (NfcTag tag) async {
        try {
          final card = Iso7816.from(tag);
          if (card == null) {
            throw Exception("未サポートのICカードです");
          }
          // TODO: この辺で履歴とか読み取る
        } catch (e, st) {
          print(e);
          print(st);
          NfcManager.instance.stopSession(errorMessage: "読み取りに失敗しました");
        }
        NfcManager.instance.stopSession(alertMessage: "読み取り成功しました");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body:Column(children: [
          const Center(child: Text('ホーム画面', style: TextStyle(fontSize: 32.0))),
          const Center(child: Text('NFC読み取り', style: TextStyle(fontSize: 32.0))),
          Center(
          child: SingleChildScrollView(
            child: ElevatedButton(
              onPressed: () => readNFC(),
              child: const Text("Touch NFC"),
              style: ElevatedButton.styleFrom(
                onPrimary: Colors.white,
              ),
            ),
          ),
        ),
      ]),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          readNFC();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),*/ 
    );
  }
}