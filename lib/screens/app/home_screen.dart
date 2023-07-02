import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:database_app/bloc/bloc/notes_bloc.dart';
import 'package:database_app/bloc/events/crud_event.dart';
import 'package:database_app/bloc/states/crud_state.dart';
import 'package:database_app/extensions/context_extension.dart';
import 'package:database_app/get/notes_getx_controller.dart';
import 'package:database_app/models/process_response.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:database_app/screens/app/note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // NotesGetxController controller = Get.put<NotesGetxController>(NotesGetxController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<NotesBloc>(context).add(ReadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Home'),
          actions: [
            IconButton(
              onPressed: (){
                _showLogoutConfirmDialog(context);
                },
              icon: Icon(Icons.logout),
            ),
            IconButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context)=> NoteScreen(),
                  ),
                );
                },
              icon: Icon(Icons.note_add_outlined),
            ),
          ],
        ),
      body: BlocConsumer<NotesBloc,CrudState>(
        listenWhen: (previous, current) =>
        current is ProcessState &&
            current.processType == ProcessType.delete,
        listener: (context,state){
          state as ProcessState;
          context.showSnackBar(message: state.message, error: !state.status);
        },
        buildWhen: (previous, current) =>
        current is LoadingState || current is ReadState,
        builder: (context, state){
          if(state is LoadingState){
            return Center(child: CircularProgressIndicator());
          }else if(state is ReadState && state.notes.isNotEmpty){
            return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index){
                  return ListTile(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) =>
                            NoteScreen(note: state.notes[index],
                            ),
                      ),
                      );
                    },
                    leading: Icon(Icons.note_add_outlined),
                    title: Text(state.notes[index].title),
                    subtitle: Text(state.notes[index].info),
                    trailing: IconButton(
                      onPressed: (){
                        BlocProvider.of<NotesBloc>(context).add(DeleteEvent(index));
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
                });
          }else {
            return Center(
              child: Text(
                'NO DATA',style:  GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              ),
            );
            }
          },
        ),

      );

  //   body: GetX<NotesGetxController>(
  //     init: NotesGetxController(),
  //     global: true,builder: (NotesGetxController controller){
  // if(controller.loading.isTrue){
  // return Center(
  // child: CircularProgressIndicator(),
  // );
  // }
  // else if (controller.notes.isNotEmpty) {
  // return ListView.builder(
  // itemCount: controller.notes.length,
  // itemBuilder: (context, index) {
  // return ListTile(
  // onTap: (){
  // Navigator.push(context,MaterialPageRoute(
  // builder: (context)=> NoteScreen(note:controller.notes[index],
  // ),
  // ),
  // );
  // },
  // leading: Icon(Icons.note),
  // title: Text(controller.notes[index].title),
  // subtitle: Text(controller.notes[index].info),
  // trailing: IconButton(
  // onPressed: () => _delete(index),
  // icon: Icon(Icons.delete),
  // ),
  // );
  // }
  // );
  // }
  // else
  // return Center(
  // child: Text(
  // 'No Data',
  // style: GoogleFonts.cairo(
  // fontWeight: FontWeight.bold,
  // fontSize: 24.sp,
  // color: Colors.black45,
  // ),
  // ),
  // );
  //
  // },
  //
  //   ),

}

void _delete(int index) async {
  ProcessResponse processResponse =
  await NotesGetxController.to.delete(index);
  context.showSnackBar(
    message: processResponse.massage,
    error: !processResponse.success,
  );
}

void _showLogoutConfirmDialog(BuildContext context) async {
  bool? result = await showDialog<bool>(
    // barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Confirm Logout!'),
          content: Text('Are you sure?'),
          titleTextStyle: GoogleFonts.cairo(
              fontSize: 18.sp
              , fontWeight: FontWeight.bold,
              color: Colors.black),
          contentTextStyle: GoogleFonts.cairo(
              fontSize: 14.sp,
              fontWeight: FontWeight.w300,
              height: 1.0,
              color: Colors.black45),
          actions: [
            TextButton
              (onPressed: () {
              Navigator.pop(context, true);
            },
              child: Text(
                'Confirm',
                style: GoogleFonts.cairo(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton
              (onPressed: () {
              Navigator.pop(context, false);
            },
              child: Text(
                'Cancel',
                style: GoogleFonts.cairo(
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        );
      });
  if (result ?? false) {
    bool cleared = await SharedPrefController().clear();
    if (cleared) {
      await Get.delete<NotesGetxController>();
      Navigator.pushReplacementNamed(context, '/login_screen');
    }
  }
}}
