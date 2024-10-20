import 'package:asia_cargo_ashir_11_boss_office/bloc/bilty_bloc.dart';
import 'package:asia_cargo_ashir_11_boss_office/database/data_base_service.dart';
import 'package:asia_cargo_ashir_11_boss_office/firebase_options.dart';
import 'package:asia_cargo_ashir_11_boss_office/pages/first_page.dart';
import 'package:asia_cargo_ashir_11_boss_office/routes/on_generate_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

final dataBaseGetIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  dataBaseGetIt.registerSingleton<DataBaseService>(DataBaseService());
  runApp(
    const MainApp(),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BiltyBloc(),
        ),
      ],
      child: const MaterialApp(
        checkerboardOffscreenLayers: false,
        
        onGenerateRoute: onGenerateRoute,
        initialRoute: FirstPage.pageName,
      ),
    );
  }
}
