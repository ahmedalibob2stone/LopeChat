

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class Searchfor extends ConsumerStatefulWidget {
  const Searchfor({Key? key}) : super(key: key);

  @override
  ConsumerState<Searchfor> createState() => _SearchforState();
}

class _SearchforState extends ConsumerState<Searchfor> {

  @override
  Widget build(BuildContext context) {
    //final uid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(


      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').orderBy('name')  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return ListTile(
                    onTap: () {


                    },

                    title: Text(data['name']),
                   // subtitle: Text(data['lastMassge']),
                  );
                });
          }),
    );
  }
}

