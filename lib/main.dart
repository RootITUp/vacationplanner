import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/consts/states.dart';
import 'package:vacation_planner/repositories/vacation_repository.dart';
import 'package:vacation_planner/yearly_calender_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configs");
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
  int paidLeaveDays = 30;
  int restPaidLeaveDays = 0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          BlocBuilder<VacationCubit, VacationState>(builder: (context, state) {
        if (state is VacationLoadSuccess) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                setState(() {});
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: const Text("Konfiguration"),
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: TextFormField(
                                        initialValue: GlobalConfiguration()
                                            .getValue("maxLeaveDays")
                                            .toString(),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Bitte gebe etwas ein';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Urlaubstage"),
                                        ),
                                        onSaved: (newValue) => setState(() {
                                          paidLeaveDays = int.parse(newValue!);
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: TextFormField(
                                        initialValue: 0.toString(),
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text("Rest-Urlaubstage"),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Bitte gebe etwas ein';
                                          }
                                          return null;
                                        },
                                        onSaved: (newValue) => setState(() {
                                          restPaidLeaveDays =
                                              int.parse(newValue!);
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      final form = _formKey.currentState;
                                      if (form!.validate()) {
                                        form.save();
                                        GlobalConfiguration().updateValue(
                                            "maxLeaveDays",
                                            paidLeaveDays + restPaidLeaveDays);
                                      }
                                    },
                                    child: const Text("OK"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              child: Text(
                (GlobalConfiguration().getValue("maxLeaveDays") -
                        state.leaveList.length)
                    .toString(),
                textScaleFactor: 2,
              ),
            ),
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
                        onPressed: () {},
                        icon: const Icon(Icons.zoom_out_outlined)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.zoom_in_outlined)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share_outlined))
                  ],
                  expandedHeight: 180,
                  floating: true,
                  primary: true,
                  backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.black),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 16, top: kToolbarHeight),
                            child: Text(
                              "Hi, Rafa!",
                              textScaleFactor: 2.5,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 64),
                            child: Text(
                              "Für das Jahr 2022 verbleiben dir noch " +
                                  (GlobalConfiguration()
                                              .getValue("maxLeaveDays") -
                                          state.leaveList.length)
                                      .toString() +
                                  " Urlaubstage.",
                              textScaleFactor: 1.5,
                            ),
                          ),
                        ]),
                  ),
                ),
                SliverToBoxAdapter(
                  child: YearlyCalendar(updateHolidayDays,
                      state: state,
                      year: 2022,
                      states: _selectedState,
                      showHolidays: isShowHolidays,
                      showVacations: isShowVacations,
                      numberColumns: isZoomedIn ? 1 : 2),
                ),
              ],
            ),
          );
        } else {
          return Container();
        }
      }),
    );
  }

  updateHolidayDays() {
    setState(() {});
  }
}
