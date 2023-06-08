import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_hub/providers/accounts_screen_providers.dart';

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
    final emailErr = ref.watch(invalidEmailStateProvider);
    final pwdErr = ref.watch(invalidPwdStateProvider);
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
          ElevatedButton(
              onPressed: () {
                final validEmail =
                    AcountService.validateEmail(emailcontroller.text);
                final validPass =
                    AcountService.validatePassword(passcontroller.text);
                if (!validEmail) {
                  ref.read(invalidEmailStateProvider.notifier).state =
                      "Invalid Email";
                }
                if (!validPass) {
                  ref.read(invalidPwdStateProvider.notifier).state =
                      "Weak Password";
                }
                if (validEmail && validPass) {}
              },
              child: const Text("Sign Up")),
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
                    ref.read(emailControllerProvider).clear();
                    ref.read(passControllerProvider).clear();
                    ref.read(invalidEmailStateProvider.notifier).state = null;
                    ref.read(invalidPwdStateProvider.notifier).state = null;
                    ref.read(showPassStateProvider.notifier).state = false;
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
    );
  }
}
