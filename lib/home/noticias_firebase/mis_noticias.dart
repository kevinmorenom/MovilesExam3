import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_ext_api/item_noticia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    Stream mis_noticias =
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
                stream: mis_noticias,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  return RefreshIndicator(
                    child: ListView(
                      children:
                          snapshot.data.docs.map((DocumentSnapshot document) {
                        return new ItemNoticia(
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
                    },
                  );
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
