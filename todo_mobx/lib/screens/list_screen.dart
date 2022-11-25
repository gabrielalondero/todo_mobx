import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:todo_mobx/stores/list_store.dart';
import 'package:todo_mobx/stores/login_store.dart';

import '../widgets/custom_icon_button.dart';
import '../widgets/custom_text_field.dart';
import 'login_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final ListStore listStore = ListStore();
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Tarefas',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32),
                    ),
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      color: Colors.white,
                      onPressed: () {
                        //listen: false - pois a função so é chamada uma vez.
                        //com isso, ele não vai ficar obtendo atualizações sempre que tiver 
                        //uma atualização no provider
                        Provider.of<LoginStore>(context, listen: false).logout();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Observer(builder: (_) {
                          return CustomTextField(
                            controller: controller,
                              hint: 'Tarefa',
                              obscure: false,
                              onChanged: listStore.setNewTodoTitle,
                              suffix: listStore
                                      .isFormValid //se o texto não estiver vazio
                                  ? CustomIconButton(
                                      radius: 32,
                                      iconData: Icons.add,
                                      onTap: (){
                                        listStore.addTodo();
                                        controller.clear();
                                        },
                                    )
                                  : null //caso estiver vazio, não mostra o botão
                              );
                        }),
                        const SizedBox(height: 8),
                        //este primeiro observer confere as mudanças ocorridas nos nós da lista, 
                        //quando ambos são adicionados ou removidos
                        Expanded(child: Observer(builder: (_) {
                          return ListView.separated(
                            itemCount: listStore.todoList.length,
                            itemBuilder: (_, index) {
                              final todo = listStore.todoList[index];
                              //este observer mais interno está responsável 
                              //por identificar as mudanças internas do estado dos dados do tile
                              return Observer(builder: (_) {
                                return ListTile(
                                  title: Text(
                                    todo.title,
                                    style: TextStyle(
                                      decoration: todo
                                              .done //se a tarefa estiver concluída
                                          ? TextDecoration
                                              .lineThrough //vai riscar o texto
                                          : null, //senão, deixa o texto normal
                                      color: todo.done
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                  onTap: todo
                                      .toggleDone, //quando tocar no item, muda o estado dele
                                );
                              });
                            },
                            separatorBuilder: (_, __) {
                              return const Divider();
                            },
                          );
                        })),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
