import 'package:appdesign/components/crud.dart';
import 'package:appdesign/components/customform.dart';
import 'package:appdesign/components/valid.dart';
import 'package:appdesign/constants/linkapi.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  GlobalKey<FormState> formstate = GlobalKey();

  Crud _crud = Crud();

  bool isLoading = false;

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
    if (formstate.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      var response = await _crud.postRequest(linkSignUp, {
        "name": username.text,
        "email": email.text,
        "password": password.text
      });
      /*setState(() {
      isLoading = false;
    });*/

      if (response['status'] == "success") {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("success", (route) => false);
      } else {
        print("SignUp Fail");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signup"),
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
                              return validInput(val, 3, 20);
                            },
                            hint: 'username',
                            mycontroller: username,
                          ),
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
                              await signUp();
                            },
                            child: Text("Signup"),
                          ),
                          MaterialButton(
                            color: Colors.blueAccent,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, 'login');
                            },
                            child: Text("Login"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
