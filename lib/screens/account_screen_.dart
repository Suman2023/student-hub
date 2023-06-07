// // ignore_for_file: use_build_context_synchronously, unused_result

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:student_hub/providers/accounts_screen_providers.dart';

// class AccountScreen extends ConsumerWidget {
//   const AccountScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Size size = MediaQuery.of(context).size;
//     final isAuthenticated = ref.watch(isAuthenticatedProvider);
//     return SafeArea(
//       child: Scaffold(
//         // resizeToAvoidBottomInset: false,
//         body: isAuthenticated.when(
//           data: (data) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: size.width,
//                 ),
//                 const CircleAvatar(
//                   radius: 50,
//                 ),
//                 // ElevatedButton(
//                 //     onPressed: () async {
//                 //       await AccountDbHelper.clearAccountTable();
//                 //     },
//                 //     child: const Text("Clear accounts")),
//                 data == null
//                     ? getAuthenticateButton(context, ref, size)
//                     : Chip(label: Text(data["email"])),
//                 const SizedBox(
//                   height: 30,
//                 ),
//                 data != null
//                     ? ListTile(
//                         tileColor: Colors.red[400],
//                         title: const Text("Log Out"),
//                         trailing: const Icon(Icons.logout),
//                         onTap: () async {
//                           await ref.read(accountServiceProvider).signOut();
//                           ref.refresh(isAuthenticatedProvider.future);
//                         },
//                       )
//                     : const SizedBox(),
//               ],
//             );
//           },
//           error: (a, b) => const Text(""),
//           loading: () => const Text(""),
//         ),
//       ),
//     );
//   }

//   ElevatedButton getAuthenticateButton(
//       BuildContext context, WidgetRef ref, Size size) {
//     return ElevatedButton(
//       onPressed: () => showDialog(
//         context: context,
//         builder: ((context) =>
//             StatefulBuilder(builder: (context, StateSetter setState) {
//               final showpass = ref.watch(showPassStateProvider);
//               final isSignInFlow = ref.watch(isSignInAuthStateProvider);
//               final isLoading = ref.watch(authSignLoadingStateProvider);
//               final emailcontroller = ref.watch(emailControllerProvider);
//               final passcontroller = ref.watch(passControllerProvider);
//               return Dialog(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15.0)),
//                 child: SizedBox(
//                   // height: size.height * .75,
//                   width: size.width * .95,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 4.0,
//                       vertical: 40.0,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         TextFormField(
//                           controller: emailcontroller,
//                           onChanged: (String newval) {
//                             setState(() {});
//                           },
//                           decoration: InputDecoration(
//                             hintText: "Enter Email",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         TextFormField(
//                           controller: passcontroller,
//                           obscureText: !showpass,
//                           decoration: InputDecoration(
//                             hintText: "Enter Password",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                           ),
//                         ),

//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Checkbox(
//                               value: showpass,
//                               onChanged: (bool? newVal) {
//                                 ref.read(showPassStateProvider.notifier).state =
//                                     newVal!;
//                                 setState(() {});
//                               },
//                             ),
//                             const Text("show password"),
//                           ],
//                         ),
//                         // const FlutterLogo(
//                         //   size: 150,
//                         // ),
//                         // ElevatedButton(
//                         //     onPressed: () {
//                         //       AccountDbHelper.getAllCred();
//                         //     },
//                         //     child: Text("Clear Table")),
//                         ElevatedButton(
//                           onPressed: (emailcontroller.text.isEmpty ||
//                                   passcontroller.text.isEmpty)
//                               ? null
//                               : () async {
//                                   debugPrint(
//                                     "Signedin with ${emailcontroller.text} and ${passcontroller.text}",
//                                   );
//                                   ref
//                                       .read(isSignInAuthStateProvider.notifier)
//                                       .state = true;
//                                   // final response = await ref
//                                   //     .read(accountDbHelperProvider)
//                                   //     .getCred(emailcontroller.text);
//                                   // print("Response: $response");
//                                   // if (response != null) {
//                                   final data = isSignInFlow
//                                       ? await ref
//                                           .read(accountServiceProvider)
//                                           .signin(
//                                             email: emailcontroller.text,
//                                             password: passcontroller.text,
//                                           )
//                                       : await ref
//                                           .read(accountServiceProvider)
//                                           .signup(
//                                             email: emailcontroller.text,
//                                             password: passcontroller.text,
//                                           );
//                                   // TODO: use the below for signup
//                                   if (data != null) {
//                                     final id = await ref
//                                         .read(accountDbHelperProvider)
//                                         .saveCred(data.email, data.password,
//                                             data.csrftoken, data.sessionid);
//                                     if (id > 0) {
//                                       ref.refresh(
//                                           isAuthenticatedProvider.future);
//                                       emailcontroller.clear();
//                                       passcontroller.clear();
//                                       Navigator.of(context).pop();
//                                     } else {
//                                       ref
//                                           .read(isSignInAuthStateProvider
//                                               .notifier)
//                                           .state = false;
//                                     }
//                                     debugPrint("ID: $id");
//                                   }
//                                 },
//                           // },
//                           child: isLoading
//                               ? const CircularProgressIndicator()
//                               : isSignInFlow
//                                   ? const Text("Sign In")
//                                   : const Text("Sign Up"),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             isSignInFlow
//                                 ? const Text("No Account yet?")
//                                 : const Text("Already Have an account? "),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   ref
//                                       .read(isSignInAuthStateProvider.notifier)
//                                       .state = !(isSignInFlow);
//                                 });
//                               },
//                               child: isSignInFlow
//                                   ? const Text(
//                                       "register",
//                                       style: TextStyle(color: Colors.blue),
//                                     )
//                                   : const Text(
//                                       "login",
//                                       style: TextStyle(color: Colors.blue),
//                                     ),
//                             ),
//                           ],
//                         ),
//                         // ElevatedButton(
//                         //   onPressed: () {
//                         //     Navigator.of(context).pop();
//                         //   },
//                         //   child: const Text("Close"),
//                         // )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             })),
//       ),
//       child: const Text("Authenticate"),
//     );
//   }
// }
