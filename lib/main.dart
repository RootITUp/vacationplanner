import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/calendar_month_creator.dart';
import 'package:vacation_planner/repositories/vacation_repository.dart';
import 'package:vacation_planner/yearly_calender_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => VacationRepository(),
          )
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => VacationCubit(
                  vacationRepository:
                      RepositoryProvider.of<VacationRepository>(context)),
            )
          ],
          child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primaryColor: const Color(0xff06D6A0),
              textTheme: GoogleFonts.poppinsTextTheme().apply(
                bodyColor: Colors.grey[900],
                displayColor: Colors.grey[900],
              ),
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSwatch().copyWith(
                secondary: const Color(0xff118AB2),
              ),
            ),
            locale: const Locale('de_DE'),
            debugShowCheckedModeBanner: false,
            home: const MyHomePage(title: 'Flutter Demo Home Page'),
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    context.read<VacationCubit>().loadVacations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.share_outlined))
              ],
              expandedHeight: 180,
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              flexibleSpace: FlexibleSpaceBar(
                background: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(left: 16, top: kToolbarHeight),
                        child: Text(
                          "Hi, Rafa!",
                          textScaleFactor: 2.5,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 64),
                        child: Text(
                          "Für das Jahr 2022 verbleiben dir noch 30 Urlaubstage.",
                          textScaleFactor: 1.5,
                        ),
                      ),
                    ]),
              ),
            ),
            SliverToBoxAdapter(
              child: YearlyCalendar(
                year: 2022,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
