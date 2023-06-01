import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_hub/providers/feed_screen_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../providers/accounts_screen_providers.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(builder: (context, ref, child) {
            final imagefile = ref.watch(pickedFileStateProvider);
            final loading = ref.watch(postInProgressStateProvider);
            return TextButton(
                onPressed: () async {
                  ref.read(postInProgressStateProvider.notifier).state = true;
                  String? downloadurl;
                  if (imagefile != null || _textController.text.isNotEmpty) {
                    // TODO : show a loading with a blurred bg and when done take them to home with refresh
                    try {
                      final authdetails = await ref
                          .read(accountDbHelperProvider)
                          .getCurrentUserCred();
                      if (authdetails == null) {
                        throw Exception("No User found.. Signin again");
                      }
                      String username = authdetails['email'];
                      String filename = username.split("@")[0] +
                          DateTime.now().toIso8601String();
                      if (imagefile != null) {
                        final data = await storage.ref(filename).putFile(
                            imagefile,
                            SettableMetadata(customMetadata: {
                              'uploaded_by': 'Username',
                              'description': 'Some description...'
                            }));
                        downloadurl = await data.ref.getDownloadURL();
                      }
                      debugPrint(authdetails['csrftoken']);
                      final success =
                          await ref.read(feedServiceProvider).addPost(
                                text: _textController.text,
                                imageurl: downloadurl ?? "",
                                csrftoken: authdetails['csrftoken'],
                                sessionid: authdetails['sessionid'],
                              );
                      if (success) {
                        ref.read(postInProgressStateProvider.notifier).state =
                            false;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Posted Successfuly")));
                      } else {
                        ref.read(postInProgressStateProvider.notifier).state =
                            false;
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed")));
                      }
                    } catch (e) {
                      debugPrint("SOmething went wrong while posting: $e");
                    }

                    debugPrint("The url for the upload is: $downloadurl");
                  }
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Post"));
          })
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 25,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 2.0),
                  child: Chip(
                    label: Text("Public"),
                  ),
                ),
                const Spacer(),
                Consumer(builder: (context, ref, child) {
                  return IconButton(
                    onPressed: () async {
                      final XFile? pickedImage =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedImage != null) {
                        ref.read(pickedFileStateProvider.notifier).state =
                            File(pickedImage.path);
                      }
                    },
                    icon: const FaIcon(
                      FontAwesomeIcons.camera,
                    ),
                  );
                })
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(52, 2, 2, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autofocus: true,
                      maxLength: 240,
                      minLines: 1,
                      maxLines: 30,
                      controller: _textController,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                      ),
                    ),
                    Consumer(builder: (context, ref, child) {
                      final imagefile = ref.watch(pickedFileStateProvider);
                      return imagefile != null
                          ? Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                  Image.file(imagefile),
                                  IconButton(
                                    onPressed: () {
                                      ref
                                          .read(
                                              pickedFileStateProvider.notifier)
                                          .state = null;
                                    },
                                    icon: const FaIcon(
                                      FontAwesomeIcons.x,
                                      color: Colors.black,
                                    ),
                                  ),
                                ])
                          : Container();
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
