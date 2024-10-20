import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';

class BiltyDetailedPage extends StatelessWidget {
  const BiltyDetailedPage(
      {super.key, required this.biltyNumber, required this.biltyUrl});

  static const pageName = 'biltyDetailedPage';

  final String biltyNumber;
  final String biltyUrl;

  //  Future<void> _openImage(String url) async {
  //   try {
  //     // Get the temporary directory
  //     final tempDir = await getTemporaryDirectory();
  //     final tempPath = tempDir.path;

  //     // Download the file
  //     final response = await http.get(Uri.parse(url));
  //     final file = File('$tempPath/bilty_image.jpg');
  //     await file.writeAsBytes(response.bodyBytes);

  //     // Open the file with the default photo application
  //     final result = await OpenFile.open(file.path);
  //     if (result.type != ResultType.done) {
  //       throw 'Could not open file';
  //     }
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<void> _openImage(String url) async {
    try {
      // Get the temporary directory
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;

      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Create the file in the temporary directory
        final file = File('$tempPath/bilty_image.jpg');
        // Write the image bytes to the file
        await file.writeAsBytes(response.bodyBytes);

        // Open the file with the default photo application
        final result = await OpenFile.open(file.path);
        if (result.type != ResultType.done) {
          throw 'Could not open file';
        }
      } else {
        throw 'Failed to download image';
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bilty Number: $biltyNumber',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    _openImage(biltyUrl);
                 
                  },
                  child: PhotoView.customChild(
                    minScale: PhotoViewComputedScale.contained * 0.9,
                    // tightMode: true,
                    // filterQuality: FilterQuality.high,
                    // wantKeepAlive: true,
                    child: Image.network(
                      biltyUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        }
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text('Failed to load image'),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // PhotoView.customChild(child: Image.network('src'))

              
              // Expanded(
              //   child: GestureDetector(
              //     onTap: () => _openImage(biltyUrl),
              //     child: CachedNetworkImage(
              //       imageUrl: biltyUrl,
              //       fit: BoxFit.cover,
              //       progressIndicatorBuilder: (context, url, downloadProgress) {
              //         return Center(
              //           child: CircularProgressIndicator(
              //             value: downloadProgress.progress,
              //           ),
              //         );
              //       },
              //       errorWidget: (context, url, error) =>
              //           const Icon(Icons.error),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
