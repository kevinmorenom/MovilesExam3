import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/search_bloc.dart';
import 'item_noticia.dart';

class NoticiasDeportes extends StatefulWidget {
  const NoticiasDeportes({Key key}) : super(key: key);

  @override
  _NoticiasDeportesState createState() => _NoticiasDeportesState();
}

class _NoticiasDeportesState extends State<NoticiasDeportes> {
  var query = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: FutureBuilder(
    //     future: NewsRepository().getAvailableNoticias("sports"),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    return BlocConsumer<SearchBloc, SearchState>(listener: (context, state) {
      if (state is LoadApiNewsState) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Cargando...'),
            ),
          );
      } else if (state is FailedApiNewsState) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text("${state.fail}"),
            ),
          );
      }
    }, builder: (context, state) {
      if (state is LoadedApiNewsState) {
        //si no hay nada en la lista
        if (state.noticiasExternasList.length == 0) {
          return Column(
            children: [
              SearchBar(query: query),
              _apiNews(state.noticiasExternasList)
            ],
          );
        } else if (state.noticiasExternasList.length > 0) {
          return Column(
            children: [
              SearchBar(query: query),
              _apiNews(state.noticiasExternasList),
            ],
          );
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SearchBar(query: query),
                CircularProgressIndicator(),
              ],
            ),
          );
        }
      } else {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }

  Widget _apiNews(noticiasExternas) {
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: noticiasExternas.length,
          itemBuilder: (context, index) {
            return ItemNoticia(
              noticia: noticiasExternas[index],
            );
          },
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.query,
  }) : super(key: key);

  final TextEditingController query;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: query,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          MaterialButton(
            child: Text('Search'),
            onPressed: () {
              BlocProvider.of<SearchBloc>(context).add(RequestQueryNewsEvent(
                query: query.text,
              ));
            },
          ),
        ],
      ),
    );
  }
}
