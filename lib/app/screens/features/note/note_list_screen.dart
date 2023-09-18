import 'package:flutter/material.dart';
import 'package:flutter_core_v3/app/screens/features/note/models/note_model.dart';
import 'package:flutter_core_v3/app/screens/features/note/widgets/note_widget.dart';
import 'package:flutter_core_v3/core/state_management/view/CoreGetReactiveComponent.dart';
import 'package:get/get.dart';

import '../../../services/database/database_provider.dart';
import 'controllers/note_controller.dart';
import 'note_add_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key});

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  @override
  Widget build(BuildContext context) {

    final NoteController controller = Get.find();
    controller.initData();

    return Obx(() => ListView.builder(
        itemBuilder: (context, index) => NoteWidget(
          note: controller.notes[index],
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Obx(() =>NoteAddScreen(
                      note: controller.notes[index],
                      actionMode: ActionModeEnum.update,
                    ))));
            setState(() {});
          },
          onLongPress: () async {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text(
                        'Are you sure you want to delete this note?'),
                    actions: [
                      ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.red)),
                        onPressed: () async {

                        },
                        child: const Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('No'),
                      ),
                    ],
                  );
                });
          },
        ),
      itemCount: controller.notes.value.length
    )
    );

    // return FutureBuilder<List<NoteModel>?>(
    //   // future: DatabaseProvider.getAllNotes()
    //    future: controller.getAllNotes(),
    //   builder: (context, AsyncSnapshot<List<NoteModel>?> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const CircularProgressIndicator();
    //     } else if (snapshot.hasError) {
    //       return Center(child: Text(snapshot.error.toString()));
    //     } else if (snapshot.hasData) {
    //       if (snapshot.data != null) {
    //         return ListView.builder(
    //           itemBuilder: (context, index) => NoteWidget(
    //             note: snapshot.data![index],
    //             onTap: () async {
    //               await Navigator.push(
    //                   context,
    //                   MaterialPageRoute(
    //                       builder: (context) => NoteAddScreen(
    //                             note: snapshot.data![index],
    //                           )));
    //               setState(() {});
    //             },
    //             onLongPress: () async {
    //               showDialog(
    //                   context: context,
    //                   builder: (context) {
    //                     return AlertDialog(
    //                       title: const Text(
    //                           'Are you sure you want to delete this note?'),
    //                       actions: [
    //                         ElevatedButton(
    //                           style: ButtonStyle(
    //                               backgroundColor:
    //                                   MaterialStateProperty.all(Colors.red)),
    //                           onPressed: () async {
    //                             await DatabaseProvider.deleteNote(
    //                                 snapshot.data![index]);
    //                             Navigator.pop(context);
    //                             setState(() {});
    //                           },
    //                           child: const Text('Yes'),
    //                         ),
    //                         ElevatedButton(
    //                           onPressed: () => Navigator.pop(context),
    //                           child: const Text('No'),
    //                         ),
    //                       ],
    //                     );
    //                   });
    //             },
    //           ),
    //           itemCount: snapshot.data!.length,
    //         );
    //       }
    //       return const Center(
    //         child: Text('No notes yet'),
    //       );
    //     }
    //     return const SizedBox.shrink();
    //   },
    // );
  }
}
