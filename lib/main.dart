import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_bloc/business_logic_layer/bloc/post_bloc.dart';
import 'package:learn_bloc/data/repesetory/post.repesetory.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:learn_bloc/view/screen/signe_up/login.dart';
import 'package:learn_bloc/view/widget/nav.app.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => PostBloc(RepistoryServices()),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // theme: ThemeData.dark(),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.userChanges(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                return const NavBar();
              } else {
                return const LogIn();
              }
            }),
          ),
        ));
  }
}
