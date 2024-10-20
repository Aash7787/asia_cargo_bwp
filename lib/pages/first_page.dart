// ignore: unused_import
import 'dart:developer';

import 'package:asia_cargo_ashir_11_boss_office/pages/bilty_detailed_page.dart';
import 'package:asia_cargo_ashir_11_boss_office/pages/dialog/dialog_for_update.dart';
import 'package:asia_cargo_ashir_11_boss_office/pages/dialog/my_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// import 'package:image_picker/image_picker.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  static const pageName = 'firstPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      floatingActionButton: FloatingActionButton(
        onPressed: () => _dialog(context),
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey.shade300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(
              flex: 5,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Icon(
                    Icons.arrow_back,
                    size: 35,
                  ),
                ),
              ),
            ),
            // const Spacer(flex: 2), // Added spacing for better visual separation
            const Expanded(
              flex: 60,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(flex: 5),
                    Text(
                      'User Manual',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(flex: 10),
                    Expanded(
                      child: Text(
                        'Tap on "+" to add Bilty to cloud',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(height: 5),
                    Expanded(
                      child: Text('Double tap on Bilty you want to update'),
                    ),
                    Spacer(
                      flex: 10,
                    )
                  ],
                ),
              ),
            ),
            const Spacer(
              flex: 20,
            ),
          ],
        ),
      ),
      // floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      appBar: AppBar(
        title: const Text('All Bilty Entered'),
      ),
      body: const Center(
        child: MySearchBar(),
      ),
    );
  }
  
  _dialog(context) {
        showDialog(
            context: context,
            builder: (context) => Animate(
              effects: const [
                FadeEffect(
                  duration: Duration(milliseconds: 500),
                ),
                SlideEffect()
              ],
              child: const Dialog(
                shadowColor: Colors.grey,
                insetPadding: EdgeInsets.all(25),
                child: MyDialog(),
              ),
            ),
          );
  }
}

class MySearchBar extends StatefulWidget {
  const MySearchBar({super.key});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  static const collectionBiltyInfo = 'biltyInfo';

  static const _orderBy = 'biltyNumber';

  static const _hintInSearchBar = 'Search';

  late TextEditingController searchEditingController;

  List _listFromFireStore = [];

  List _resultListFromFirestore = [];

  @override
  void initState() {
    super.initState();
    searchEditingController = TextEditingController();
    searchEditingController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchEditingController.dispose();
    searchEditingController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SearchBar(
            hintText: _hintInSearchBar,
            controller: searchEditingController,
            keyboardType: TextInputType.number,
            trailing: [
              IconButton(
                onPressed: () {
                  setState(() {
                    getData();
                  });
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  searchEditingController.clear();
                },
                icon: const Icon(Icons.clear_outlined),
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 900,
            child: ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                var document = _resultListFromFirestore[index];
                return ListTile(
                  title: Text(
                    '${document[_orderBy]}',
                    style: const TextStyle(
                      fontSize: 30,
                    ),
                  ),
                  onLongPress: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => Animate(
                        effects: const [
                          FadeEffect(
                            duration: Duration(milliseconds: 500),
                          ),
                          SlideEffect()
                        ],
                        child: Dialog(
                          shadowColor: Colors.grey,
                          insetPadding: const EdgeInsets.all(25),
                          child: DialogForUpdate(
                            upDateBilty: '${document[_orderBy]}',
                          ),
                        ),
                      ),
                    );

                    log('${document[_orderBy]}');
                  },
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      BiltyDetailedPage.pageName,
                      arguments: {
                        'biltyNumber': document[_orderBy],
                        'biltyUrl': document['biltyUrl'],
                        // Adjust the key based on your Firestore data structure
                      },
                    );
                  },
                );
              },
              itemCount: _resultListFromFirestore.length,
            ),
          ),
        ),
      ],
    );
  }

  void _onSearchChanged() {
    // log(searchEditingController.text);
    searchResultList();
  }

  void getData() async {
    var data = await FirebaseFirestore.instance
        .collection(collectionBiltyInfo)
        .orderBy(_orderBy)
        .get();
    setState(() {
      _listFromFireStore = data.docs;
    });
    searchResultList();
  }

  void searchResultList() {
    String searchQuery = searchEditingController.text.toLowerCase();
    List<dynamic> showResult;

    if (searchQuery.isNotEmpty) {
      showResult = _listFromFireStore.where((clintSnapshot) {
        var name = clintSnapshot[_orderBy].toString().toLowerCase();
        return name.contains(searchQuery);
      }).toList();
    } else {
      showResult = List.from(_listFromFireStore);
    }

    setState(() {
      _resultListFromFirestore = showResult;
    });
  }
}
