import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_login/home/noticias_firebase/item_noticia_firebase.dart';
import 'package:google_login/models/new.dart';

import 'bloc/my_news_bloc.dart';

class MisNoticias extends StatefulWidget {
  MisNoticias({Key key}) : super(key: key);

  @override
  _MisNoticiasState createState() => _MisNoticiasState();
}

class _MisNoticiasState extends State<MisNoticias> {
  @override
  Widget build(BuildContext context) {
    //Stream que cada que cambia algo en firebase, atualiza el snapshot
    Stream misNoticias =
        FirebaseFirestore.instance.collection('noticias').snapshots();
    return BlocProvider(
      create: (context) => MyNewsBloc()..add(RequestAllNewsEvent()),
      child: BlocConsumer<MyNewsBloc, MyNewsState>(
        listener: (context, state) {
          if (state is LoadingState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Cargando..."),
                ),
              );
          } else if (state is ErrorMessageState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("${state.errorMsg}"),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is LoadedNewsState) {
            return StreamBuilder<QuerySnapshot>(
                stream: misNoticias,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data.size > 0) {
                    return RefreshIndicator(
                      child: ListView(
                        children:
                            snapshot.data.docs.map((DocumentSnapshot document) {
                          return new ItemNoticiaFirebase(
                            noticia: New(
                              source: null,
                              author: document['author'],
                              title: document['title'],
                              description: document['description'],
                              url: document['url'],
                              urlToImage: document['urlToImage'],
                              publishedAt:
                                  DateTime.parse(document["publishedAt"]),
                              // content: element['content'],
                              // //
                            ),
                          );
                        }).toList(),
                      ),
                      // child: ListView.builder(
                      //   itemCount: state.noticiasList.length,
                      //   itemBuilder: (BuildContext context, int index) {
                      //     return ItemNoticia(noticia: state.noticiasList[index]);
                      //   },
                      // ),
                      onRefresh: () async {
                        print('Refresh Indicator');
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text("Noticias Actualizadas"),
                            ),
                          );
                      },
                    );
                  } else {
                    return Center(child: Text("No tienes noticias guardadas"));
                  }
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
