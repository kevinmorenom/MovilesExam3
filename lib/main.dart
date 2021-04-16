import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_login/bloc/auth_bloc.dart';
import 'package:google_login/home/home_page.dart';
import 'package:google_login/login/login_page.dart';
import 'package:google_login/utils/news_repository.dart';
import 'package:google_login/splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'models/new.dart';
import 'models/source.dart';

void main() async {
  // inicializar firebase
  WidgetsFlutterBinding.ensureInitialized();

  /// acceder a localstorage
  final _localStorage = await getExternalStorageDirectory();
  // inicializar Hive pasando path a local storage
  Hive
    ..init(_localStorage.path)
    ..registerAdapter(NewsAdapter())
    ..registerAdapter(NewAdapter())
    ..registerAdapter(SourceAdapter());
  await Hive.openBox("Noticias");

  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => AuthBloc()..add(VerifyAuthenticationEvent()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AlreadyAuthState) return HomePage();
          if (state is UnAuthState) return LoginPage();
          return SplashScreen();
        },
      ),
    );
  }
}
