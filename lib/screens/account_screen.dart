import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/providers/accounts_screen_providers.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Size size = MediaQuery.of(context).size;
    final emailcontroller = ref.watch(emailControllerProvider);
    final passcontroller = ref.watch(passControllerProvider);
    // final showpass = ref.watch(showPassStateProvider);
    return SafeArea(
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 50,
          ),
          ElevatedButton(
            onPressed: () => showDialog(
              context: context,
              builder: ((context) =>
                  StatefulBuilder(builder: (context, StateSetter setState) {
                    final showpass = ref.watch(showPassStateProvider);
                    return Dialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      child: SizedBox(
                        // height: size.height * .75,
                        width: size.width * .95,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4.0,
                            vertical: 40.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: emailcontroller,
                                decoration: InputDecoration(
                                  hintText: "Enter Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                controller: passcontroller,
                                obscureText: !showpass,
                                decoration: InputDecoration(
                                  hintText: "Enter Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: showpass,
                                    onChanged: (bool? newVal) {
                                      ref
                                          .read(showPassStateProvider.notifier)
                                          .state = newVal!;
                                      setState(() {});
                                    },
                                  ),
                                  Text("show password"),
                                ],
                              ),
                              // const FlutterLogo(
                              //   size: 150,
                              // ),
                              ElevatedButton(
                                onPressed: () async {
                                  debugPrint(
                                    "Signedin with ${emailcontroller.text} and ${passcontroller.text}",
                                  );

                                  final response = await ref
                                      .read(accountDbHelperProvider)
                                      .getCred(emailcontroller.text);
                                  print("Response: $response");
                                  if (response != null) {
                                    await ref
                                        .read(accountServiceProvider)
                                        .signin(
                                          email: emailcontroller.text,
                                          password: passcontroller.text,
                                          csrftoken: response['csrftoken'],
                                        );
                                    // TODO: use the below for signup
                                    // if (response != null) {
                                    //   final id = await ref
                                    //       .read(accountDbHelperProvider)
                                    //       .saveCred(
                                    //           response.email,
                                    //           response.password,
                                    //           response.csrftoken);
                                    //   debugPrint("ID: $id");
                                    // }
                                  }
                                },
                                child: const Text("Sign In"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("No account? "),
                                  GestureDetector(
                                    onTap: () {
                                      debugPrint("tapped register");
                                    },
                                    child: Text(
                                      "register",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              ),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     Navigator.of(context).pop();
                              //   },
                              //   child: const Text("Close"),
                              // )
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            ),
            child: const Text("Sign Up"),
          ),
          const SizedBox(
            height: 30,
          ),
          const ListTile(
            tileColor: Colors.grey,
          ),
        ],
      )),
    );
  }
}
