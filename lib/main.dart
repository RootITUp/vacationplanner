import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/consts/states.dart';
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
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('de', ''), // English, no country code
              Locale('en', ''), // Spanish, no country code
            ],
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
    initializeDateFormatting();

    context.read<VacationCubit>().loadVacations();
  }

  final _states = States.values;
  States _selectedState = States.NW;
  bool isShowHolidays = true;
  bool isShowVacations = true;
  bool isZoomedIn = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.3),
                  child: const Text(
                    "R",
                    style: TextStyle(color: Colors.black),
                    textScaleFactor: 2,
                  ),
                ),
                accountEmail: null,
                accountName: const Text(
                  'Rafael',
                  style: TextStyle(fontSize: 24.0),
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Dein Bundesland: ")),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: _states.map((state) {
                            return DropdownMenuItem(
                                value: state,
                                child: Row(
                                  children: <Widget>[
                                    Text(state.toLongString()),
                                  ],
                                ));
                          }).toList(),
                          onChanged: (States? newValue) {
                            // do other stuff with _category
                            setState(() => _selectedState = newValue!);
                          },
                          value: _selectedState,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Zeige Feiertage: ")),
                    Checkbox(
                      value: isShowHolidays,
                      onChanged: (newValue) {
                        setState(() {
                          isShowHolidays = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Zeige Schulferien: ")),
                    Checkbox(
                      value: isShowVacations,
                      onChanged: (newValue) {
                        setState(() {
                          isShowVacations = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              child: GestureDetector(
                onDoubleTap: () => setState(() {
                  isZoomedIn = !isZoomedIn;
                }),
                child: YearlyCalendar(
                    year: 2022,
                    states: _selectedState,
                    showHolidays: isShowHolidays,
                    showVacations: isShowVacations,
                    numberColumns: isZoomedIn ? 1 : 2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
