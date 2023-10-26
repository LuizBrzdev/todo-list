import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_cubit/src/home/cubit/cubits/board_cubit.dart';
import 'package:todo_list_cubit/src/home/pages/board_page.dart';
import 'package:todo_list_cubit/src/home/repositories/board_repository.dart';
import 'package:todo_list_cubit/src/home/repositories/isar/isar_board_repository.dart';
import 'package:todo_list_cubit/src/home/repositories/isar/isar_datasource.dart';

void main() async {
  Intl.defaultLocale = 'pt_BR';
  initializeDateFormatting();
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(create: (context) => IsarDatasource()),
        RepositoryProvider<BoardRepository>(
            create: (context) => IsarBoardRepository(context.read())),
        BlocProvider(create: (context) => BoardCubit(context.read()))
      ],
      child: MaterialApp(
        home: const BoardPage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          fontFamily: 'DMSans',
        ),
      ),
    );
  }
}
