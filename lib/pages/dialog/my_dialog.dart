import 'dart:developer';
import 'dart:typed_data';

import 'package:asia_cargo_ashir_11_boss_office/database/data_base_service.dart';
import 'package:asia_cargo_ashir_11_boss_office/main.dart';
import 'package:asia_cargo_ashir_11_boss_office/model/bilty.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({super.key});

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  late TextEditingController dialogInputController;

  String? imageUrl;

  String dialogValue = '';

  @override
  void initState() {
    super.initState();
    dialogInputController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    dialogInputController.dispose();
  }

  Uint8List? data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 3.5),
        borderRadius: BorderRadius.circular(25),
      ),
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 250,
            child: TextFormField(
              controller: dialogInputController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                // dialogValue = value;
                log('${dialogInputController.text} value');
              },
              decoration: const InputDecoration(
                // hintText: 'Enter Bilty Number',
                labelText: 'Enter Bilty Number',
                // prefix: Icon(Icons.abc),
                // suffix: Icon(Icons.abc),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              var image =
                  await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
              if (image != null) {
                data = await image.readAsBytes();
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image is clicked '),
                  ),
                );
              } else {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image is not clicked'),
                  ),
                );
              }
            },
            child: const Text('Press to open Camera'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () async {
                    final dataBaseService = dataBaseGetIt<DataBaseService>();
                    try {
                      if (data != null) {
                        await FirebaseStorage.instance
                            .ref()
                            .child('Images')
                            .child('Image${dialogInputController.text}')
                            .putData(data!)
                            .then(
                          (taskSnapshot) async {
                            imageUrl = await taskSnapshot.ref.getDownloadURL();
                            log(imageUrl!);
                          },
                        );
                      }

                      dataBaseService.addBilty(Bilty(
                          biltyNumber: int.parse(dialogInputController.text),
                          biltyUrl: imageUrl!));
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Image Added'),
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Something went wrong'),
                      ));
                    }
                  },
                  child: const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
