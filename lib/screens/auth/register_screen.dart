import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:database_app/database/user_db_controller.dart';
import 'package:database_app/extensions/context_extension.dart';
import 'package:database_app/models/process_response.dart';
import 'package:database_app/models/users.dart';
import '../../widgets/app_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);


  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  late TextEditingController _nameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:  Text(context.localization.register),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 15.w,
            vertical: 15.h
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localization.register_title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: Colors.black,
              ),
            ),
            Text(
              context.localization.register_subtitle,
              style: GoogleFonts.poppins(
                height: 1,
                fontWeight: FontWeight.w300,
                fontSize: 14.sp,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: _nameTextController,
              prefixIcon: Icons.person,
              hint: context.localization.name,
              textInputType: TextInputType.name,
            ),
            SizedBox(height: 10.h),
            AppTextField(
              controller: _emailTextController,
              prefixIcon: Icons.email,
              hint: context.localization.email,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10.h),
            AppTextField(
              controller: _passwordTextController,
              prefixIcon: Icons.lock,
              hint: context.localization.password,
              obscureText: true,
            ),
            SizedBox(height: 10.h),
            ElevatedButton(
              onPressed: ()=> _performLogin(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity,50.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                  context.localization.register,
                style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
               ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  void _performLogin(){
    if(_checkData()){
      _login();
    }
  }

  bool _checkData(){
    if(_emailTextController.text.isNotEmpty
        && _passwordTextController.text.isNotEmpty){
      return true;
    }
    context.showSnackBar(message: context.localization.error_data);
    return false;
  }

  void _login() async{
    ProcessResponse processResponse = await UserDbController().register(user: user);
    if(processResponse.success) {
      Navigator.pop(context);
    }
    context.showSnackBar(
      message: processResponse.massage,
      error: !processResponse.success,
    );
  }
  User get user {
    User user = User();
    user.name = _nameTextController.text;
    user.email= _emailTextController.text;
    user.password = _passwordTextController.text;
    return user;
  }
}


