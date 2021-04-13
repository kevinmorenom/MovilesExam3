import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/models/new.dart';

import 'bloc/my_news_bloc.dart';

class PantallaTres extends StatefulWidget {
  const PantallaTres({Key key}) : super(key: key);
  @override
  _PantallaTresState createState() => _PantallaTresState();
}

class _PantallaTresState extends State<PantallaTres> {
  MyNewsBloc _bloc;
  File selectedImage;
  var autorTc = TextEditingController();

  var tituloTc = TextEditingController();

  var descrTc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _bloc = MyNewsBloc();
        return _bloc;
      },
      child: BlocConsumer<MyNewsBloc, MyNewsState>(
        listener: (context, state) {
          if (state is PickedImageState) {
            selectedImage = state.image;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Imagen seleccionada"),
                ),
              );
          } else
          //borrar datos del formulario
          if (state is SavedNewState) {
            autorTc.clear();
            tituloTc.clear();
            descrTc.clear();
            selectedImage = null;
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text("Noticia Guardada..."),
                ),
              );
          }
        },
        builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return _createForm();
        },
      ),
    );
  }

  Widget _createForm() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            selectedImage != null
                ? Image.file(
                    selectedImage,
                    fit: BoxFit.contain,
                    height: 120,
                    width: 120,
                  )
                : Container(
                    height: 120,
                    width: 120,
                    child: Placeholder(),
                  ),
            SizedBox(height: 16),
            TextField(
              controller: autorTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Autor',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: tituloTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Titulo',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descrTc,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Descripcion',
              ),
            ),
            SizedBox(height: 16),
            MaterialButton(
              child: Text("Subir Imagen"),
              onPressed: () {
                _bloc.add(PickImageEvent());
              },
            ),
            SizedBox(height: 16),
            MaterialButton(
              child: Text("Guardar"),
              onPressed: () {
                _bloc.add(
                  SaveNewElementEvent(
                    noticia: New(
                      author: autorTc.text,
                      title: tituloTc.text,
                      description: descrTc.text,
                      publishedAt: DateTime.now(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
