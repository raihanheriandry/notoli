import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notoli/providers/theme_provider.dart';
import 'package:notoli/theme/app_theme.dart';
import 'package:notoli/pages/splash.dart';
import 'package:provider/provider.dart';
import 'package:notoli/providers/settings_provider.dart';
import 'package:notoli/providers/note_provider.dart';
import 'package:notoli/repository/note_repo.dart';
import 'package:notoli/repository/folder_repo.dart';
import 'package:notoli/repository/tag_repo.dart';
import 'package:notoli/providers/auth_provider.dart';
import 'package:notoli/repository/auth_repo.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'db/db_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();
  await DatabaseHelper.instance.database;

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  runApp(const NotoliApp());
}

class NotoliApp extends StatelessWidget {
  const NotoliApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthRepo())),

        ChangeNotifierProxyProvider<AuthProvider, NoteProvider>(
          create: (_) => NoteProvider(
            noteRepo: NoteRepo(),
            folderRepo: FolderRepo(),
            tagRepo: TagRepo(),
            username: null,
          ),
          update: (_, auth, previous) {
            final username = auth.userCurrent?.username;
            if (previous == null || previous.username != username) {
              return NoteProvider(
                noteRepo: NoteRepo(),
                folderRepo: FolderRepo(),
                tagRepo: TagRepo(),
                username: username,
              );
            }
            return previous;
          },
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Notoli',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
