import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:database_app/bloc/bloc/notes_bloc.dart';
import 'package:database_app/bloc/events/crud_event.dart';
import 'package:database_app/bloc/states/crud_state.dart';
import 'package:database_app/extensions/context_extension.dart';
import 'package:database_app/models/note.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import '../../widgets/app_text_field.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen({Key? key, this.note}) : super(key: key);
  final Note? note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {

  late TextEditingController _titleTextController;
  late TextEditingController _infoTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleTextController = TextEditingController(text: widget.note?.title);
    _infoTextController = TextEditingController(text: widget.note?.info);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleTextController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(title),
        actions: [
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NotesBloc, CrudState>(
            listenWhen: (previous, current)=>
            current is ProcessState &&
                (current.processType == ProcessType.create ||
                    current.processType == ProcessType.update),
            listener: (context, state){
              state as ProcessState;
              context.showSnackBar(message: state.message, error: !state.status);
              if(state.status){
                state.processType == ProcessType.create
                    ? clear()
                    : Navigator.pop(context);
              }
            },
          ),
        ],
        child:Padding(
      padding: EdgeInsets.symmetric(
      horizontal: 15.w,
          vertical: 15.h
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextField(
            controller: _titleTextController,
            prefixIcon: Icons.title,
            hint: context.localization.title,
            textInputType: TextInputType.text,
          ),
          SizedBox(height: 10.h),
          AppTextField(
            controller: _infoTextController,
            prefixIcon: Icons.info,
            hint: context.localization.info,
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: ()=> _performSave(),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity,50.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              context.localization.save,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),

            ),
          ),
        ],
      ),
    ),
      ),
    );
  }

  bool get isNewNote => widget.note == null;

  String get title =>
      isNewNote ? context.localization.create : context.localization.update;

  void _performSave(){
    if(_checkData()){
      _save();
    }
  }

  bool _checkData(){
    if(_titleTextController.text.isNotEmpty &&
        _infoTextController.text.isNotEmpty){
      return true;
    }
    return false;
  }

  void _save(){
    isNewNote
        ? BlocProvider.of<NotesBloc>(context).add(CreateEvent(note))
        : BlocProvider.of<NotesBloc>(context).add(UpdateEvent(note));
  }
    void clear() {
      _titleTextController.clear();
      _infoTextController.clear();
    }

    Note get note {
      Note note = isNewNote ? Note() : widget.note!;
      note.title = _titleTextController.text;
      note.info = _infoTextController.text;
      note.userId =
      SharedPrefController().getValueFor<int>(key: PrefKeys.id.name)!;
      return note;
    }
  }

