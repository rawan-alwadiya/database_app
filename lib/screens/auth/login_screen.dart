import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:database_app/database/user_db_controller.dart';
import 'package:database_app/extensions/context_extension.dart';
import 'package:database_app/models/process_response.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:database_app/provider/language_provider.dart';
import '../../widgets/app_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  late String _language;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _language= SharedPrefController().getValueFor<String>(key: PrefKeys.language.name) ?? 'en';
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.login),
        actions: [
          IconButton(
            onPressed: (){
              _showLanguageBottomSheet();
            },
            icon: Icon(Icons.language),
          ),
        ],
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
              AppLocalizations.of(context)!.login_title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
                color: Colors.black,
              ),
            ),
            Text(
              AppLocalizations.of(context)!.login_subtitle,
              style: GoogleFonts.poppins(
                height: 1,
                fontWeight: FontWeight.w300,
                fontSize: 14.sp,
                color: Colors.black45,
              ),
            ),
            SizedBox(height: 20.h),
            AppTextField(
              controller: _emailTextController,
              prefixIcon: Icons.email,
              hint: AppLocalizations.of(context)!.email,
              textInputType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10.h),
            AppTextField(
              controller: _passwordTextController,
              prefixIcon: Icons.lock,
              hint: AppLocalizations.of(context)!.password,
              obscureText: true,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: ()=> _performLogin(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity,50.sp),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                  AppLocalizations.of(context)!.login,
                style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
               ),

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.have_no_account),
                TextButton(
                  onPressed: ()=>Navigator.pushNamed(context, '/register_screen'),
                  child: Text(AppLocalizations.of(context)!.create_now),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet() async{
    String? langCode = await showModalBottomSheet<String>(
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.r),
              topRight: Radius.circular(10.r),
          ),
        ),
        builder: (context){
          return StatefulBuilder(builder: (context,setState){
            return BottomSheet(
                onClosing: (){},
                builder: (context){
                  return Padding(
                    padding:  EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 20.h
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.language_title,
                          style: GoogleFonts.cairo(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.language_subtitle,
                          style: GoogleFonts.cairo(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                              height: 1.0,
                              color: Colors.black45
                          ),
                        ),
                        Divider(),
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'English',
                            style: GoogleFonts.cairo(),
                          ),
                          value: 'en',
                          groupValue: _language,
                          onChanged: (String? value){
                            if(value!=null){
                              setState(()=>_language=value);
                              Navigator.pop(context,'en');
                            }
                          },
                        ),
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'العربية',
                            style: GoogleFonts.cairo( ),
                          ),
                          value: 'ar',
                          groupValue: _language,
                          onChanged: (String? value){
                            if(value!=null){
                              setState(()=>_language=value);
                              Navigator.pop(context,'ar');
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }
            );
          });
        }

    );
    if(langCode!= null){
      Future.delayed(Duration(milliseconds: 500),(){
        Provider.of<LanguageProvider>(context,listen: false).changeLanguage();
      });
    }
  }

  void _performLogin(){
    if(_checkData()){
      _login();
    }
  }

  bool _checkData(){
    if(_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty){
      return true;
    }
    return false;
  }

  void _login() async{
    ProcessResponse processResponse = await UserDbController().login(
        email: _emailTextController.text,
        password: _passwordTextController.text
    );
    if(processResponse.success){
    Navigator.pushReplacementNamed(context, '/home_screen');
    }
    context.showSnackBar(
        message: processResponse.massage,
        error: !processResponse.success
    );
  }


}


