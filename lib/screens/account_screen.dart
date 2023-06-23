import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_hub/providers/accounts_screen_providers.dart';
import '../database/account_db_helper.dart';
import '../services/accounts_service.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  PageController? pageController;
  @override
  void initState() {
    final isloggedIn = ref.read(isLoggedInStateProvider);
    debugPrint("isloggedIn: $isloggedIn");
    pageController = PageController(initialPage: isloggedIn ? 0 : 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          AuthorizedScreen(
            pageController: pageController!,
          ),
          SignInFlow(
            pageController: pageController!,
          ),
          SignUpFlow(
            pageController: pageController!,
          ),
        ],
      ),
    );
  }
}

class AuthorizedScreen extends ConsumerStatefulWidget {
  const AuthorizedScreen(
      {super.key, required this.pageController, this.random});
  final PageController pageController;
  final String? random;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthorizedScreenState();
}

class _AuthorizedScreenState extends ConsumerState<AuthorizedScreen> {
  final _picker = ImagePicker();
  void clearCache() async {
    Directory cacheDir = await getTemporaryDirectory();
    cacheDir.deleteSync(recursive: true);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authentication = ref.watch(isAuthenticatedProvider);
    return SafeArea(
      child: Scaffold(
          body: authentication.when(
        data: (data) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(isAuthenticatedProvider.future),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width,
                ),
                const CircleAvatar(
                  radius: 50,
                ),
                Chip(
                  label: Text(data == null ? "" : data["email"]),
                ),
                Expanded(
                    child: ListView(
                  children: [
                    ListTile(
                      tileColor: Colors.red[400],
                      leading: const Icon(
                        Icons.logout,
                      ),
                      title: const Text(
                        "Log Out",
                      ),
                      onTap: () async {
                        await ref.read(accountServiceProvider).signOut();
                        ref.read(isLoggedInStateProvider.notifier).state =
                            false;
                        widget.pageController.jumpToPage(1);
                      },
                    ),

                    ListTile(
                      // tileColor: Colors.red[400],
                      leading: const Icon(
                        Icons.feedback_outlined,
                      ),
                      title: const Text(
                        "Provide Feedback",
                      ),
                      onTap: () async {
                        debugPrint("clicked feedback");
                        _showFeedbackModalSheet(context).then((value) => null);
                      },
                    ),

                    // TODO: Remove this in prod
                    // ListTile(
                    //   tileColor: Colors.redAccent,
                    //   title: Text("Clear Account DB"),
                    //   onTap: () async {
                    //     await AccountDbHelper.clearAccountTable();
                    //     ref.read(isLoggedInStateProvider.notifier).state =
                    //         false;

                    //     setState(() {
                    //       ref.refresh(isAuthenticatedProvider.future);
                    //     });
                    //   },
                    // ),
                  ],
                ))
              ],
            ),
          );
        },
        error: (obj, stk) => const Center(
          child: Text("Something went Wrong!"),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      )),
    );
  }

  Future<dynamic> _showFeedbackModalSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 1.0,
        expand: false,
        builder: (BuildContext context, ScrollController scrollController) {
          return Consumer(builder: (context, ref, child) {
            final feedbackFile = ref.watch(feedbackFileProvider);
            final feedbackTextController = ref.watch(feedbackTextProvider);
            final isLoading = ref.watch(feedbackLoadingProvider);
            return Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 8.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                      width: double.infinity,
                      // child: Center(
                      //   child: Container(
                      //       height: 5,
                      //       width: 25,
                      //       color: Colors.black),
                      // ),
                    ),
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          TextFormField(
                            controller: feedbackTextController,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                labelText: "Enter Feedback",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      ref
                                          .read(feedbackTextProvider.notifier)
                                          .state
                                          .clear();
                                    },
                                    icon: const Icon(Icons.clear_outlined))),
                          ),
                          Visibility(
                            visible: feedbackFile != null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    feedbackFile != null
                                        ? basename(feedbackFile.path) * 10
                                        : "",
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref
                                        .read(feedbackFileProvider.notifier)
                                        .state = null;
                                  },
                                  child: const Text(
                                    'reset',
                                  ),
                                )
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final file = await _picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (file != null) {
                                ref.read(feedbackFileProvider.notifier).state =
                                    File(
                                  file.path,
                                );
                              }
                            },
                            child: const Text(
                              "Add screenshot",
                            ),
                          ),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    ref
                                        .read(feedbackLoadingProvider.notifier)
                                        .state = true;
                                    final success = await ref
                                        .read(feedbackServiceProvider)
                                        .sendFeedback(
                                          text: feedbackTextController.text,
                                          filePath: feedbackFile?.path,
                                        );
                                    ref
                                        .read(feedbackLoadingProvider.notifier)
                                        .state = false;
                                    if (!mounted) return;
                                    if (success) {
                                      ref
                                          .read(feedbackFileProvider.notifier)
                                          .state = null;
                                      ref.read(feedbackTextProvider).clear();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.green[200],
                                          content: const Text(
                                            "Thank You for the feedback",
                                          ),
                                        ),
                                      );
                                    } else if (!success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.red[200],
                                          content: const Text(
                                            "Something went wrong. Please try Again",
                                          ),
                                        ),
                                      );
                                    }
                                  },
                            child: isLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : const Text("Submit"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class SignInFlow extends ConsumerWidget {
  const SignInFlow({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPwd = ref.watch(showPassStateProvider);
    final emailcontroller = ref.watch(emailControllerProvider);
    final passcontroller = ref.watch(passControllerProvider);
    final emailErr = ref.watch(invalidEmailStateProvider);
    final pwdErr = ref.watch(invalidPwdStateProvider);
    final isLoading = ref.watch(authSignLoadingStateProvider);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: emailcontroller,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: "Enter Email",
                errorText: emailErr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onChanged: emailErr == null
                  ? null
                  : (value) =>
                      ref.read(invalidEmailStateProvider.notifier).state = null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: passcontroller,
              obscureText: !showPwd,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
              ),
              decoration: InputDecoration(
                hintText: "Enter Password",
                errorText: pwdErr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              onChanged: pwdErr == null
                  ? null
                  : (value) =>
                      ref.read(invalidPwdStateProvider.notifier).state = null,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: showPwd,
                onChanged: (bool? newVal) {
                  ref.read(showPassStateProvider.notifier).state = newVal!;
                },
              ),
              const Text("show password"),
            ],
          ),
          SizedBox(
            height: 36,
            width: size.width * .40,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final validEmail =
                          AcountService.validateEmail(emailcontroller.text);
                      if (!validEmail) {
                        ref.read(invalidEmailStateProvider.notifier).state =
                            "Invalid Email";
                      }
                      if (validEmail && passcontroller.text.isNotEmpty) {
                        ref.read(authSignLoadingStateProvider.notifier).state =
                            true;
                        final response = await ref
                            .read(accountServiceProvider)
                            .signin(
                                email: emailcontroller.text,
                                password: passcontroller.text);
                        debugPrint("Response: ${response.csrftoken}");
                        if (response.csrftoken.isEmpty) {
                          ref
                              .read(authSignLoadingStateProvider.notifier)
                              .state = false;
                        } else {
                          ref.invalidate(isAuthenticatedProvider);
                          pageController.jumpToPage(0);
                          ref
                              .read(authSignLoadingStateProvider.notifier)
                              .state = false;
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Sign In",
                    ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No Account Yet? "),
              GestureDetector(
                  onTap: () {
                    pageController.animateToPage(
                      2,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      curve: Curves.easeInOut,
                    );
                    ref.read(emailControllerProvider).clear();
                    ref.read(passControllerProvider).clear();
                    ref.read(invalidEmailStateProvider.notifier).state = null;
                    ref.read(invalidPwdStateProvider.notifier).state = null;
                    ref.read(showPassStateProvider.notifier).state = false;
                  },
                  child: const Text(
                    "REGISTER",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}

class SignUpFlow extends ConsumerWidget {
  const SignUpFlow({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showPwd = ref.watch(showPassStateProvider);
    final emailcontroller = ref.watch(emailControllerProvider);
    final passcontroller = ref.watch(passControllerProvider);
    final firstNamecontroller = ref.watch(firstNameControllerProvider);
    final lastNamecontroller = ref.watch(lastNameControllerProvider);
    final emailErr = ref.watch(invalidEmailStateProvider);
    final pwdErr = ref.watch(invalidPwdStateProvider);
    final firstNameErr = ref.watch(invalidFirstNameStateProvider);
    final lastNameErr = ref.watch(invalidLastNameStateProvider);
    final isLoading = ref.watch(authSignLoadingStateProvider);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: size.height * .25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailcontroller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  // labelText: "Enter Email",
                  // alignLabelWithHint: true,
                  // floatingLabelAlignment: FloatingLabelAlignment.center,
                  hintText: "Enter Email",
                  errorText: emailErr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onChanged: emailErr == null
                    ? null
                    : (value) => ref
                        .read(invalidEmailStateProvider.notifier)
                        .state = null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: passcontroller,
                obscureText: !showPwd,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  errorText: pwdErr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onChanged: pwdErr == null
                    ? null
                    : (value) =>
                        ref.read(invalidPwdStateProvider.notifier).state = null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: firstNamecontroller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  hintText: "Enter First Name",
                  errorText: firstNameErr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onChanged: pwdErr == null
                    ? null
                    : (value) => ref
                        .read(invalidFirstNameStateProvider.notifier)
                        .state = null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: lastNamecontroller,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Last Name",
                  errorText: lastNameErr,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onChanged: pwdErr == null
                    ? null
                    : (value) => ref
                        .read(invalidLastNameStateProvider.notifier)
                        .state = null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: showPwd,
                  onChanged: (bool? newVal) {
                    ref.read(showPassStateProvider.notifier).state = newVal!;
                  },
                ),
                const Text("show password"),
              ],
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      final validEmail =
                          AcountService.validateEmail(emailcontroller.text);
                      final validPass =
                          AcountService.validatePassword(passcontroller.text);
                      final validFirstName = AcountService.isFirstNameValid(
                          firstNamecontroller.text);
                      final validLastName = AcountService.isFirstNameValid(
                          lastNamecontroller.text);
                      if (!validEmail) {
                        ref.read(invalidEmailStateProvider.notifier).state =
                            "Invalid Email";
                      }
                      if (!validPass) {
                        ref.read(invalidPwdStateProvider.notifier).state =
                            "Weak Password";
                      }
                      if (!validFirstName) {
                        ref.read(invalidFirstNameStateProvider.notifier).state =
                            "Invalid First Name\nRequired Minimum 2 character and no special";
                      }
                      if (!validLastName) {
                        ref.read(invalidLastNameStateProvider.notifier).state =
                            "Invalid Last Name\nRequired Minimum 2 character and no special";
                      }
                      if (validEmail &&
                          validPass &&
                          validFirstName &&
                          validLastName) {
                        ref.read(authSignLoadingStateProvider.notifier).state =
                            true;
                        final response = await ref
                            .read(accountServiceProvider)
                            .signup(
                                email: emailcontroller.text,
                                password: passcontroller.text,
                                firstName: firstNamecontroller.text,
                                lastName: lastNamecontroller.text);

                        if (response != null) {
                          resetState(ref);
                          ref.invalidate(isAuthenticatedProvider);
                          pageController.jumpToPage(0);
                        }
                        ref.read(authSignLoadingStateProvider.notifier).state =
                            false;
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Register",
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                    onTap: () {
                      pageController.animateToPage(
                        1,
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        curve: Curves.easeInOut,
                      );
                      resetState(ref);
                    },
                    child: const Text(
                      "SIGN IN",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void resetState(WidgetRef ref) {
    ref.read(emailControllerProvider).clear();
    ref.read(passControllerProvider).clear();
    ref.read(firstNameControllerProvider).clear();
    ref.read(lastNameControllerProvider).clear();
    ref.read(invalidEmailStateProvider.notifier).state = null;
    ref.read(invalidPwdStateProvider.notifier).state = null;
    ref.read(invalidFirstNameStateProvider.notifier).state = null;
    ref.read(invalidLastNameStateProvider.notifier).state = null;
    ref.read(showPassStateProvider.notifier).state = false;
    ref.read(authSignLoadingStateProvider.notifier).state = false;
  }
}
