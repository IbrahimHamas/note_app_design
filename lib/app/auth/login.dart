import 'package:appdesign/components/crud.dart';
import 'package:appdesign/components/customform.dart';
import 'package:appdesign/components/valid.dart';
import 'package:appdesign/constants/linkapi.dart';
import 'package:appdesign/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Crud crud = Crud();

  bool isLoading = false;

  login() async {
    if (formstate.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      var response = await crud.postRequest(
          linkLogin, {"email": email.text, "password": password.text});

      setState(() {
        isLoading = false;
      });

      if (response['status'] == "success") {
        sharedPref.setString("id", response['data']['id'].toString());
        sharedPref.setString("name", response['data']['name']);
        sharedPref.setString("email", response['data']['email']);
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        AwesomeDialog(
            context: context,
            title: "تنبيه",
            body: Text("البريد الالكتروني او كلمة المرور أو الحساب غير موجود"))
          ..show();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: EdgeInsets.all(20),
                child: ListView(
                  children: [
                    Form(
                      key: formstate,
                      child: Column(
                        children: [
                          Image.asset("images/logo.png",
                              width: 200, height: 200, fit: BoxFit.fill),
                          CustomForm(
                            valid: (val) {
                              return validInput(val, 5, 40);
                            },
                            hint: 'email',
                            mycontroller: email,
                          ),
                          CustomForm(
                            valid: (val) {
                              return validInput(val, 3, 10);
                            },
                            hint: 'password',
                            mycontroller: password,
                          ),
                          MaterialButton(
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () async {
                              await login();
                            },
                            child: Text("Login"),
                          ),
                          MaterialButton(
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushNamed('signup');
                            },
                            child: Text("Signup"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
