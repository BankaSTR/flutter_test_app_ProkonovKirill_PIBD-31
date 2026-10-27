import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_app/components/locale/l10n/app_locale.dart';
import 'package:flutter_test_app/data/repositories/like_api_repository.dart';
import 'package:flutter_test_app/data/repositories/project_api_repository.dart';
import 'package:flutter_test_app/domain/repositories/like_repository.dart';
import 'package:flutter_test_app/domain/repositories/project_repository.dart';
import 'package:flutter_test_app/presentation/home_page/bloc/bloc.dart';
import 'package:flutter_test_app/presentation/home_page/home_page.dart';
import 'package:flutter_test_app/presentation/like_bloc/like_bloc.dart';
import 'package:flutter_test_app/presentation/locale_bloc/locale_bloc.dart';
import 'package:flutter_test_app/presentation/locale_bloc/locale_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final ProjectRepository? repository;
  final LikeRepository? likeRepository;

  const MyApp({super.key, this.repository, this.likeRepository});

  @override
  Widget build(BuildContext context) {
    final projectRepository = repository ?? ProjectApiRepository();
    final projectLikeRepository = likeRepository ?? LikeApiRepository();

    return BlocProvider<LocaleBloc>(
      lazy: false,
      create: (context) => LocaleBloc(Locale(Platform.localeName)),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'ПРИВЕТ',
            locale: state.currentLocale,
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
            home: RepositoryProvider<ProjectRepository>.value(
              value: projectRepository,
              child: RepositoryProvider<LikeRepository>.value(
                value: projectLikeRepository,
                child: BlocProvider<LikeBloc>(
                  lazy: false,
                  create: (context) => LikeBloc(context.read<LikeRepository>()),
                  child: BlocProvider<HomeBloc>(
                    lazy: false,
                    create: (context) => HomeBloc(context.read<ProjectRepository>()),
                    child: MyHomePage(
                      title: 'Проконов Кирилл ПИбд-31',
                      repository: projectRepository,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
