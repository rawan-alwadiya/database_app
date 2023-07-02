import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:database_app/bloc/bloc/notes_bloc.dart';
import 'package:database_app/bloc/states/crud_state.dart';
import 'package:database_app/database/db_controller.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';
import 'package:database_app/provider/language_provider.dart';
import 'package:database_app/provider/notes_provider.dart';
import 'package:database_app/screens/app/home_screen.dart';
import 'package:database_app/screens/auth/login_screen.dart';
import 'package:database_app/screens/auth/register_screen.dart';
import 'package:database_app/screens/core/launch_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefController().initPreferences();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context,child){
      return MultiBlocProvider(
        providers: [
          BlocProvider<NotesBloc>(
            create: (context)=> NotesBloc(LoadingState())),
        ],
        child: MaterialApp(
        theme: ThemeData(
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            iconTheme: const IconThemeData(color: Colors.black),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleTextStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: Colors.black,
            ),
          ),
        ),
        // localizationsDelegates: const [
        //   AppLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        // ],
        // supportedLocales: const [
        //   Locale('en'),
        //   Locale('ar'),
        // ],
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: Locale('en'),
        debugShowCheckedModeBanner: false,
        initialRoute: '/launch_screen',
        routes:{
          '/launch_screen':(context)=>const LaunchScreen(),
          '/login_screen':(context)=>const LoginScreen(),
          '/register_screen':(context)=>const RegisterScreen(),
          '/home_screen':(context)=>const HomeScreen(),
        },
      ),
      );
        },
      );
  }
}

// class NewWidget extends StatelessWidget {
//   const NewWidget({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(
//         backgroundColor: Colors.white,
//         appBarTheme: AppBarTheme(
//           iconTheme: const IconThemeData(color: Colors.black),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           titleTextStyle: GoogleFonts.poppins(
//             fontWeight: FontWeight.bold,
//             fontSize: 18.sp,
//             color: Colors.black,
//           ),
//         ),
//       ),
//       // localizationsDelegates: const [
//       //   AppLocalizations.delegate,
//       //   GlobalWidgetsLocalizations.delegate,
//       //   GlobalCupertinoLocalizations.delegate,
//       //   GlobalMaterialLocalizations.delegate,
//       // ],
//       // supportedLocales: const [
//       //   Locale('en'),
//       //   Locale('ar'),
//       // ],
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       supportedLocales: AppLocalizations.supportedLocales,
//       locale: Locale(Provider.of<LanguageProvider>(context).language),
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/launch_screen',
//       routes:{
//         '/launch_screen':(context)=>const LaunchScreen(),
//         '/login_screen':(context)=>const LoginScreen(),
//         '/home_screen':(context)=>const HomeScreen(),
//       },
//     );
//   }
// }


/*
* Design Size:
* -> Width: 375
* -> Height: 812 => 8.12
*
*
* Original Height: 31
* -------------------
* Current Device Height: 812 => 8.12
* New Height: 31 * 8.12/8.12 = 31
* -------------------
* Current Device Height: 714 => 7.14
* New Height: 31 * 7,14/8.12 = 27.3
* -------------------
* New Height: (Height * currentDeviceHeight(%)) / OriginalDesignHeight(%)
* New Width: (Width * currentDeviceWidth(%)) / OriginalDesignWidth(%)
*/