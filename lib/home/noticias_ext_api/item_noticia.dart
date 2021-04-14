import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/home/noticias_subir/bloc/upload_bloc.dart';
import 'package:google_login/models/new.dart';

class ItemNoticia extends StatelessWidget {
  final New noticia;
  ItemNoticia({Key key, @required this.noticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is SavedApiNewsState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Noticia guardada en firebase"),
              ),
            );
        }
      },
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8)),
                    child: Image.network(
                      "${noticia.urlToImage}",
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${noticia.title}",
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${noticia.publishedAt}",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${noticia.description ?? "Descripcion no disponible"}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "${noticia.author ?? "Autor no disponible"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            onPressed: () {
                              print('pressed');
                              BlocProvider.of<UploadBloc>(context).add(
                                SaveApiNewsEvent(
                                  noticia: New(
                                      source: null,
                                      author: noticia.author ??
                                          "Autor no disponible",
                                      title: noticia.title,
                                      description: noticia.description ??
                                          "Descripcion no disponible",
                                      url: noticia.urlToImage,
                                      urlToImage: noticia.urlToImage,
                                      publishedAt: noticia.publishedAt),
                                  // content: element['content'],
                                  // //
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
