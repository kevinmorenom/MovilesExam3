import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_login/models/new.dart';
import 'package:image_picker/image_picker.dart';

part 'my_news_event.dart';
part 'my_news_state.dart';

class MyNewsBloc extends Bloc<MyNewsEvent, MyNewsState> {
  var _cFirestore = FirebaseFirestore.instance;
  File _selectedImage;
  MyNewsBloc() : super(MyNewsInitial());

  @override
  Stream<MyNewsState> mapEventToState(
    MyNewsEvent event,
  ) async* {
    if (event is RequestAllNewsEvent) {
      yield LoadingState();
      yield LoadedNewsState(noticiasList: await _getNoticias());
    }
    if (event is PickImageEvent) {
      yield LoadingState();
      _selectedImage = await _getImage();
      //si es nulo yield error
      yield PickedImageState(image: _selectedImage);
    }
    if (event is SaveNewElementEvent) {
      //subir el archivo
      //obtener url
      //agregar el irl
      //guardar elemento en firebase
      String imageUrl = await _uploadFile();
      if (imageUrl != null) {
        yield LoadingState();
        await _saveNoticias(
            event.noticia.copyWith(urlToImage: imageUrl, url: imageUrl));
        yield SavedNewState();
      } else {
        yield ErrorMessageState(errorMsg: "Error no se pudo guardar la imagen");
      }
    }
  }

  Future<List<New>> _getNoticias() async {
    try {
      var noticias = await _cFirestore.collection("noticias").get();
      return noticias.docs
          .map(
            (element) => New(
              source: null,
              author: element['author'],
              title: element['title'],
              description: element['description'],
              url: element['url'],
              urlToImage: element['urlToImage'],
              publishedAt: element['publishedAt'].toDate(),
              // content: element['content'],
            ),
          )
          .toList();
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<File> _getImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 720,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<String> _uploadFile() async {
    try {
      var stamp = DateTime.now();
      if (_selectedImage == null) return null;

      UploadTask task = FirebaseStorage.instance
          .ref("noticias/imagen_$stamp")
          .putFile(_selectedImage);
      await task;
      return await task.storage.ref("noticias/imagen_$stamp").getDownloadURL();
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("Error al subir la imagen: $e");
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> _saveNoticias(New noticia) async {
    try {
      await _cFirestore.collection('noticias').add(noticia.toJson());
      return true;
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
