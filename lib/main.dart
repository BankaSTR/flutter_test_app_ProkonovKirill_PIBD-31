import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/data/repositories/project_api_repository.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:flutter_test_app/presentation/home_page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final ProjectRepository? repository;

  const MyApp({super.key, this.repository});

  @override
  Widget build(BuildContext context) {
    final projectRepository = repository ?? ProjectApiRepository();

    return MaterialApp(
      title: 'ПРИВЕТ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: RepositoryProvider<ProjectRepository>.value(
        value: projectRepository,
        child: BlocProvider<HomeBloc>(
          lazy: false,
          create: (context) => HomeBloc(context.read<ProjectRepository>()),
          child: MyHomePage(
            title: 'Проконов Кирилл ПИбд-31',
            repository: projectRepository,
          ),
        ),
      ),
    );
  }
}
