import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:todo_mobx/stores/login_store.dart';

import '../widgets/custom_icon_button.dart';
import '../widgets/custom_text_field.dart';
import 'list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginStore loginStore; //vamos obter o loginStore através do provider

  //como a reação rodará infinitamente, é importante dar um dispose quando não estiver utilizando mais
  ReactionDisposer? disposer; 

  //usar o reaction dentro do didChangeDependencies() nos statefullWidgets
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    loginStore = Provider.of<LoginStore>(context);

    //o reaction atuará quando tiver uma troca do valor
    //a primeira função do reaction é utilizada para indicar o que vai monitorar
    //a segunda função é o efeito que a primeira causa. ela recebe o valor que foi modificado na função de cima
    //coloca a reação em um disposer para fechá-la depois
    disposer = reaction(
      (_) => loginStore.loggedIn, 
      (loggedIn){
        //se estiver logado, troca de página
        if(loggedIn){
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ListScreen()),
        );
        }
      }
      );
    
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(32),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 16,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Observer(builder: (_) {
                    return CustomTextField(
                      hint: 'E-mail',
                      prefix: const Icon(Icons.account_circle),
                      obscure: false,
                      textInputType: TextInputType.emailAddress,
                      //chama a função que recebe o email e atualiza o observable
                      onChanged: loginStore.setEmail,
                      enabled: !loginStore.loading, //campo habilitado caso não estiver carregando
                    );
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  Observer(builder: (_) {
                    return CustomTextField(
                      hint: 'Senha',
                      prefix: const Icon(Icons.lock),
                      obscure: loginStore.passwordObscure,
                      onChanged: loginStore.setPassword,
                      enabled: !loginStore.loading,
                      suffix: CustomIconButton(
                          radius: 32,
                          iconData: loginStore.passwordObscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                          onTap: loginStore.togglePasswordObscure),
                    );
                  }),
                  const SizedBox(
                    height: 16,
                  ),
                  Observer(
                    builder: (_) {
                      return SizedBox(
                        height: 44,
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            disabledBackgroundColor:
                                Theme.of(context).primaryColor.withAlpha(100),
                          ),
                          onPressed: loginStore.loginPressed as void Function()?,
                          child: loginStore.loading //se estiver carregando
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text('Login'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

 //para parar o reaction
  @override
  void dispose() {
    dispose();
    super.dispose();
  }
}


