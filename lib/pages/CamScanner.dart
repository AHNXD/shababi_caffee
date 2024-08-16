// ignore_for_file: file_names

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shababi_caffee/const.dart';

class CamScanner extends StatefulWidget {
  const CamScanner({super.key});
  static String id = "/CamScanner";
  @override
  State<CamScanner> createState() => _CamScannerState();
}

class _CamScannerState extends State<CamScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  String audioasset = "audio/beep.mp3";

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid || Platform.isIOS) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset:
            Platform.isAndroid || Platform.isIOS ? false : true,
        appBar: AppBar(
          backgroundColor: appColor,
          title: const Text(
            "QR",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20))),
                  child: IconButton(
                    onPressed: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    icon: FutureBuilder<bool?>(
                      future: controller?.getFlashStatus(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.data != null) {
                          return snapshot.data!
                              ? const Icon(
                                  Icons.flash_on,
                                  color: Colors.green,
                                )
                              : const Icon(
                                  Icons.flash_off,
                                  color: Colors.red,
                                );
                        } else {
                          return const Icon(
                            Icons.flash_off,
                            color: Colors.red,
                          );
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: appColor,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20))),
                  child: IconButton(
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      icon: const Icon(
                        Icons.switch_camera,
                        color: Colors.white,
                      )),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height / 2,
              width: double.infinity,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                    borderWidth: 10,
                    borderColor: appColor,
                    borderLength: 30,
                    borderRadius: 10,
                    cutOutSize: MediaQuery.of(context).size.width * 0.8),
              ),
            ),
            Divider(
              thickness: 5,
              color: appColor,
            ),
            Center(
              child: (result != null)
                  ? Text(
                      'Ip : ${result!.code}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : const Text('امـسـح الـكـود',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Divider(
              thickness: 5,
              color: appColor,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: appColor),
                onPressed: () {
                  if (result != null) {
                    Navigator.pop(context, result?.code);
                  }
                },
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                ))
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    Barcode? aux;
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (result != null && aux?.code != result?.code) {
          final player = AudioPlayer();
          player.play(AssetSource(audioasset));
          aux = result;
        }
      });
    });
  }
}
