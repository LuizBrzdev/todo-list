import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_cubit/src/home/cubit/cubits/board_cubit.dart';
import 'package:todo_list_cubit/src/home/cubit/states/board_state.dart';
import 'package:todo_list_cubit/src/home/widgets/c_dialog.dart';

class BoardPage extends StatefulWidget {
  const BoardPage({super.key});

  @override
  State<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends State<BoardPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<BoardCubit>().fetchTasks();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SafeArea(child: SizedBox(height: 20)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tarefas',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat.yMMMMd().format(DateTime.now()),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            BlocBuilder<BoardCubit, BoardState>(
              builder: (context, state) {
                return Center(
                  child: switch (state) {
                    EmptyBoardState() => Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 4,
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Ops..Parece que você ainda não tem tarefas',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey),
                              key: Key('EmptyState'),
                            ),
                          ),
                        ],
                      ),
                    LoadingBordState() => const Center(
                        child: CircularProgressIndicator(
                          key: Key('LoadingBordState'),
                        ),
                      ),
                    FailureBoardState() => const Center(
                        child: Text(
                          'Falha ao Pegar Tasks',
                          key: Key('FailureBoardState'),
                        ),
                      ),
                    GettedTaskBoardState() => ListView.separated(
                        shrinkWrap: true,
                        key: const Key('GettedBoardState'),
                        padding: EdgeInsets.zero,
                        itemCount: state.tasks.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 8),
                        itemBuilder: (context, index) => Dismissible(
                          key: Key(state.tasks[index].toString()),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            await taskDialog(
                              context: context,
                              label: 'Sim',
                              onPressed: () {
                                cubit.canDismissTask = true;
                                Navigator.of(context).pop();
                              },
                              onPressBack: () {
                                cubit.canDismissTask = false;
                                Navigator.of(context).pop();
                              },
                              content: SizedBox(
                                height: 140,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Tem certeza que deseja remover sua Tarefa ?',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      title: Text(
                                        state.tasks[index].description,
                                        style: TextStyle(
                                          color: Colors.deepPurple.withOpacity(0.8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      tileColor: Colors.deepPurple.withOpacity(0.1),
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8))),
                                    )
                                  ],
                                ),
                              ),
                            );
                            return cubit.canDismissTask;
                          },
                          onDismissed: (direction) => cubit.removeTask(state.tasks[index]),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                  offset: Offset(2, 8),
                                ),
                              ],
                            ),
                            child: CheckboxListTile(
                              checkboxShape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                              title: Text(
                                state.tasks[index].description,
                                style: TextStyle(
                                  color: !state.tasks[index].check ? Colors.black : Colors.grey,
                                  decoration: !state.tasks[index].check
                                      ? TextDecoration.none
                                      : TextDecoration.lineThrough,
                                ),
                              ),
                              value: state.tasks[index].check,
                              onChanged: (value) {
                                cubit.checkTask(state.tasks[index]);
                              },
                            ),
                          ),
                        ),
                      )
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('FloatingActionButton'),
        onPressed: () => taskDialog(
          context: context,
          label: 'Adicionar',
          onPressed: () {
            context.read<BoardCubit>().addTask();
            Navigator.of(context).pop();
          },
          onPressBack: () {
            Navigator.of(context).pop();
            cubit.taskDescription.clear();
          },
          content: SizedBox(
            height: 150,
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 16),
                TextField(
                  controller: cubit.taskDescription,
                  key: const Key('TextInput'),
                  maxLines: 3,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Descreva aqui sua Tarefa',
                    hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                  ),
                  onChanged: (value) => context.read<BoardCubit>().taskDescription,
                ),
              ],
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
