import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store{


  @observable
  String email = '';

//ação que seta o email
  @action
  void setEmail(String value) => email = value; 

  @observable
  String password = '';

  @action
  void setPassword(String value) => password = value;

  
  @observable
  bool passwordObscure = true;

  @action
  void togglePasswordObscure() => passwordObscure = !passwordObscure;

  @observable
  bool loading = false;

  @observable
  bool loggedIn = false;



  //para combinar o estado de alguns observables, utiliza-se o @computed
  //sempre que declará-lo, precisa de um getter
  @computed
  bool get isEmailValid => RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
  
  @computed
  bool get isPasswordValid =>  password.length >= 6;

  @computed
  Function? get loginPressed =>
  //se o email e senha forem válidos e não estiver carregando, retorna a função de login, senão, desabilita o botão
    (isEmailValid && isPasswordValid && !loading) ? login : null;

  @action
  Future<void> login() async {
    loading = true;

    await Future.delayed(const Duration(seconds: 2));

    loading = false;
    loggedIn = true; //quando muda, chama a reaction

  }

  @action 
  void logout(){
    loggedIn = false;
    passwordObscure = true;
    email = '';
    password = '';
  }

}
