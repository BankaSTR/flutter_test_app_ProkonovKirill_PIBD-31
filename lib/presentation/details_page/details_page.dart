import 'package:flutter/material.dart';
import 'package:flutter_test_app/domain/models/card.dart';
import 'package:flutter_test_app/presentation/project_formatters.dart';

class DetailsPage extends StatelessWidget {
  final CardData project;

  const DetailsPage(this.project, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Center(child: Icon(projectIcon(project.icon), size: 96)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              project.title,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Text(
            project.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Собрано ${formatMoney(project.collected)} ₽ '
              'из ${formatMoney(project.goal)} ₽',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: LinearProgressIndicator(
              value: project.progress.clamp(0, 100) / 100,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Text('Выполнено: ${project.progress}%'),
        ],
      ),
    );
  }
}
