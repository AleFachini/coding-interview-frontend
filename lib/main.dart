import 'package:coding_interview_frontend/core/di/injection.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/bloc/conversion_bloc.dart';
import 'package:coding_interview_frontend/features/conversion/presentation/pages/conversion_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  configureDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coding Interview Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFF5B320),
        ),
        useMaterial3: true,
      ),
      home: BlocProvider<ConversionBloc>(
        create: (_) => getIt<ConversionBloc>(),
        child: const ConversionPage(),
      ),
    );
  }
}
