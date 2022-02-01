import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/consts/states.dart';
import 'package:vacation_planner/repositories/vacation_repository.dart';
import 'package:vacation_planner/theme_provider.dart';
import 'package:vacation_planner/widgets/change_theme_button.dart';
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
          child: ChangeNotifierProvider(
            builder: (context, _) {
              final themeProvider = Provider.of<ThemeProvider>(context);
              return MaterialApp(
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('de', ''),
                  Locale('en', ''),
                ],
                title: 'Flutter Demo',
                themeMode: themeProvider.themeMode,
                theme: MyThemes.lightTheme,
                darkTheme: MyThemes.darkTheme,
                locale: const Locale('de_DE'),
                debugShowCheckedModeBanner: false,
                home: const MyHomePage(title: 'Flutter Demo Home Page'),
              );
            },
            create: (BuildContext context) {
              return ThemeProvider();
            },
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          BlocBuilder<VacationCubit, VacationState>(builder: (context, state) {
        if (state is VacationLoadSuccess) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  (Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark)
                      ? const Color(0xFF355070)
                      : Colors.white,
                  (Provider.of<ThemeProvider>(context).themeMode ==
                          ThemeMode.dark)
                      ? const Color(0xFF6d597a)
                      : Colors.white,
                ],
                begin: const FractionalOffset(1.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
              ),
            ),
            child: Scaffold(
              key: _scaffoldKey,
              floatingActionButton: FloatingActionButton(
                backgroundColor: const Color(0xffeaac8b),
                onPressed: () {
                  setState(() {});
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        backgroundColor:
                            (Provider.of<ThemeProvider>(context).themeMode ==
                                    ThemeMode.dark)
                                ? const Color(0xffeaac8b)
                                : Colors.white,
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
                                          cursorColor: const Color(0xFF6d597a),
                                          initialValue: GlobalConfiguration()
                                              .getValue("maxLeaveDays")
                                              .toString(),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Bitte gebe etwas ein';
                                            }
                                            return null;
                                          },
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Color(0xFF6d597a),
                                            )),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF6d597a)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF6d597a)),
                                            ),
                                            focusColor: Color(0xFF6d597a),
                                            hoverColor: Color(0xFF6d597a),
                                            labelStyle: TextStyle(
                                                color: Color(0xFF6d597a)),
                                            label: Text("Urlaubstage"),
                                          ),
                                          onSaved: (newValue) => setState(() {
                                            paidLeaveDays =
                                                int.parse(newValue!);
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
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Color(0xFF6d597a),
                                            )),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF6d597a)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFF6d597a)),
                                            ),
                                            focusColor: Color(0xFF6d597a),
                                            hoverColor: Color(0xFF6d597a),
                                            labelStyle: TextStyle(
                                                color: Color(0xFF6d597a)),
                                            label: Text("Rest-Urlaubstage"),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
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
                                      style: ElevatedButton.styleFrom(
                                          primary: const Color(0xFF6d597a)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        final form = _formKey.currentState;
                                        if (form!.validate()) {
                                          form.save();
                                          GlobalConfiguration().updateValue(
                                              "maxLeaveDays",
                                              paidLeaveDays +
                                                  restPaidLeaveDays);
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
                  style: TextStyle(
                      color: (Provider.of<ThemeProvider>(context).themeMode ==
                              ThemeMode.dark
                          ? Colors.white
                          : Colors.black)),
                ),
              ),
              drawer: Drawer(
                backgroundColor:
                    (Provider.of<ThemeProvider>(context).themeMode ==
                            ThemeMode.dark)
                        ? const Color(0xFF355070)
                        : Colors.white,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      currentAccountPicture: const CircleAvatar(
                        backgroundColor: Color(0xFF6d597a),
                        child: Text(
                          "R",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textScaleFactor: 2,
                        ),
                      ),
                      accountEmail: null,
                      accountName: Text(
                        'Rafael',
                        style: TextStyle(
                            fontSize: 24.0,
                            color: (Provider.of<ThemeProvider>(context)
                                        .themeMode ==
                                    ThemeMode.dark)
                                ? Colors.white
                                : Colors.black),
                      ),
                      decoration: BoxDecoration(
                        color: (Provider.of<ThemeProvider>(context).themeMode ==
                                ThemeMode.dark)
                            ? const Color(0xFF355070)
                            : Colors.white,
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
                                iconEnabledColor:
                                    (Provider.of<ThemeProvider>(context)
                                                .themeMode ==
                                            ThemeMode.dark)
                                        ? Colors.white
                                        : Colors.black,
                                dropdownColor:
                                    (Provider.of<ThemeProvider>(context)
                                                .themeMode ==
                                            ThemeMode.dark)
                                        ? const Color(0xFF6d597a)
                                        : Colors.white,
                                style: TextStyle(
                                  color: (Provider.of<ThemeProvider>(context)
                                              .themeMode ==
                                          ThemeMode.dark)
                                      ? Colors.white
                                      : Colors.black,
                                ),
                                items: _states.map((state) {
                                  return DropdownMenuItem(
                                    value: state,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(
                                          state.toLongString(),
                                          textScaleFactor: 1.2,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (States? newValue) {
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
                    const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: ChangeThemeButtonWidget(),
                    ),
                  ],
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    leading: IconButton(
                      icon: Icon(Icons.menu,
                          color:
                              (Provider.of<ThemeProvider>(context).themeMode ==
                                      ThemeMode.dark)
                                  ? Colors.white
                                  : Colors.black),
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                      },
                    ),
                    actionsIconTheme: IconThemeData(
                        color: (Provider.of<ThemeProvider>(context).themeMode ==
                                ThemeMode.dark)
                            ? Colors.white
                            : Colors.black),
                    actions: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isZoomedIn = !isZoomedIn;
                            });
                          },
                          icon: (isZoomedIn)
                              ? const Icon(
                                  Icons.zoom_out_outlined,
                                )
                              : const Icon(
                                  Icons.zoom_in_outlined,
                                )),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.share_outlined,
                            color: (Provider.of<ThemeProvider>(context)
                                        .themeMode ==
                                    ThemeMode.dark)
                                ? Colors.white
                                : Colors.black),
                      )
                    ],
                    expandedHeight: 180,
                    //floating: true,
                    primary: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16))),
                    backgroundColor: Colors.transparent,
                    iconTheme: const IconThemeData(color: Colors.black),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 16, top: kToolbarHeight),
                              child: Text(
                                "Hi, Rafa!",
                                textScaleFactor: 2.5,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 64),
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
