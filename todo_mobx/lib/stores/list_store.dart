import 'package:mobx/mobx.dart';
import 'package:todo_mobx/stores/todo_store.dart';
part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {
  @observable
  String newTodoTitle = '';

  @action
  void setNewTodoTitle(String value) {
    newTodoTitle = value;
  }

  @computed
  bool get isFormValid => newTodoTitle.isNotEmpty;

  //usa-se uma ObservableList, pois em uma lista normal, para o observável notar que ela mudou, sempre teríamos 
  //que declarar uma nova lista pegando o que já tinha na anterior, e isso não é muito correto.
  //a ObservableList, ao contrário da lista normal, é uma lista observável INTERNAMENTE.
  //ou seja, se inserirmos ou excluirmos um valor, será notado que algo mudou
  //não precisa colocar a notação @observable, pois ele já sabe que é um observable
  ObservableList<TodoStore> todoList = ObservableList<TodoStore>();

  @action
  void addTodo(){
    todoList.insert(0, TodoStore(title: newTodoTitle)); //adiciona no topo da lista o que está no newTodoTitle
    newTodoTitle = ''; //limpa
  }


      
}
