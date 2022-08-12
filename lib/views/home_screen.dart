import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weight_tracker/models/user_weight.dart';
import 'package:weight_tracker/services/auth_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  TextEditingController textController = TextEditingController();
  final inputList = [];
  List<UserWeight> userWeights = [];
  String stext = '';
  List<String> orders = [];

  @override
  Widget build(BuildContext context) {
    CollectionReference weights = FirebaseFirestore.instance
        .collection('userWeights')
        .doc(ref.watch(authProvider).user.uid)
        .collection('weights');
    var date = DateTime.now();
    var formattedDate = "${date.day}-${date.month}-${date.year}";
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                final auth = ref.watch(authProvider);
                auth.signOut();
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body: ref.watch(authProvider).isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Theme.of(context).colorScheme.secondary,
                        hintText: 'Enter your weight',
                        hintStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        contentPadding: const EdgeInsets.all(10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                      controller: textController,
                      onChanged: (text) {
                        stext = text;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // inputList.add(stext);
                        if (stext.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection('userWeights')
                              .doc(ref.watch(authProvider).user.uid)
                              .collection('weights')
                              .add({
                            'sortedDate': FieldValue.serverTimestamp(),
                            'time': formattedDate,
                            'weight': stext
                          });
                        }
                        setState(() {});
                      },
                      child: const Text('Add Weight')),
                  const SizedBox(
                    height: 10,
                  ),
                  Flexible(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: weights.orderBy('sortedDate').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text("Loading");
                        }
                        if (!snapshot.hasData) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  data['sortedDate'] != null
                                      ? Text(
                                          'Time: ${(data['sortedDate'] as Timestamp).toDate().hour}:${(data['sortedDate'] as Timestamp).toDate().minute}',
                                          style: const TextStyle(fontSize: 18),
                                        )
                                      : const Text(' '),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Weight: ${data['weight']}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        FirebaseFirestore.instance
                                            .collection('userWeights')
                                            .doc(ref
                                                .watch(authProvider)
                                                .user
                                                .uid)
                                            .collection('weights')
                                            .doc(document.id)
                                            .delete();
                                      },
                                      child: const Text('Delete'))
                                ],
                                // subtitle: Text(data['company']),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  )
                ]),
    );
  }
}
