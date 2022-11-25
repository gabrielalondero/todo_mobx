// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:mobx/mobx.dart';

part 'todo_store.g.dart';

class TodoStore = _TodoStore with _$TodoStore;

abstract class _TodoStore with Store {
  _TodoStore({required this.title});
  //não coloque observable em tudo, coloque apenas no que pode mudar de estado
  final String title;

  @observable
  bool done = false;

  @action
  void toggleDone() => done = !done;
}
