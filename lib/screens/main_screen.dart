import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:vacation_planner/blocs/vacation/vacation_bloc.dart';
import 'package:vacation_planner/blocs/vacation/vacation_state.dart';
import 'package:vacation_planner/consts/leave_type.dart';
import 'package:vacation_planner/consts/states.dart';
import 'package:vacation_planner/theme_provider.dart';

import '../yearly_calender_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _states = States.values;
  late States _selectedState;
  bool isShowHolidays = true;
  bool isShowVacations = true;
  bool isZoomedIn = false;

  int _leaveDays = 30;
  int _restLeaveDays = 0;

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey genKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    context.read<VacationCubit>().loadVacations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:
          BlocBuilder<VacationCubit, VacationState>(builder: (context, state) {
        if (state is VacationLoadSuccess) {
          _leaveDays = state.amountLeaveDays;
          _restLeaveDays = state.amountRestLeaveDays;
          _selectedState = state.selectedState;

          var leaveListOnlyPaid = state.leaveList
              .where((element) => element.type == LeaveType.paidLeave);

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
                                ? const Color(0xFF355070)
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
                                          initialValue:
                                              state.amountLeaveDays.toString(),
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
                                              color: Color(0xffeaac8b),
                                            )),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffeaac8b)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffeaac8b)),
                                            ),
                                            focusColor: Color(0xffeaac8b),
                                            hoverColor: Color(0xffeaac8b),
                                            labelStyle: TextStyle(
                                                color: Color(0xffeaac8b)),
                                            label: Text("Urlaubstage"),
                                          ),
                                          onSaved: (newValue) {
                                            setState(() {
                                              _leaveDays = int.parse(newValue!);
                                              context
                                                  .read<VacationCubit>()
                                                  .saveHolidayDays(
                                                      int.parse(newValue));
                                            });
                                          },
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
                                          initialValue: state
                                              .amountRestLeaveDays
                                              .toString(),
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                              color: Color(0xffeaac8b),
                                            )),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffeaac8b)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xffeaac8b)),
                                            ),
                                            focusColor: Color(0xffeaac8b),
                                            hoverColor: Color(0xffeaac8b),
                                            labelStyle: TextStyle(
                                                color: Color(0xffeaac8b)),
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
                                            _restLeaveDays =
                                                int.parse(newValue!);
                                            context
                                                .read<VacationCubit>()
                                                .saveRest(int.parse(newValue));
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
                                        primary: const Color(0xFF6d597a),
                                      ),
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        final form = _formKey.currentState;
                                        if (form!.validate()) {
                                          form.save();

                                          context
                                              .read<VacationCubit>()
                                              .updateAmounts();

                                          updateHolidayDays();
                                        }
                                      },
                                      child: const Text(
                                        "OK",
                                        style: (TextStyle(color: Colors.white)),
                                      ),
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
                  (_leaveDays + _restLeaveDays - leaveListOnlyPaid.length)
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
                                  setState(() {
                                    context
                                        .read<VacationCubit>()
                                        .saveState(newValue!);

                                    context
                                        .read<VacationCubit>()
                                        .updateAmounts();
                                    _selectedState = newValue;
                                  });
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
                    /* const Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: ChangeThemeButtonWidget(),
                    ),*/
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
                        onPressed: () async {
                          imageCache.clear();

                          RenderRepaintBoundary boundary = genKey.currentContext
                              ?.findRenderObject() as RenderRepaintBoundary;
                          var image = await boundary.toImage();
                          final directory =
                              (await getApplicationDocumentsDirectory()).path;
                          var byteData = await image.toByteData(
                              format: ImageByteFormat.png);
                          Uint8List? pngBytes = byteData?.buffer.asUint8List();
                          File imgFile = File('$directory/screenshot.png');
                          imgFile.writeAsBytes(pngBytes!);

                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Kalender teilen?"),
                                  content: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.white),
                                    child: Image.file(File(imgFile.path)),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Abbrechen"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final box = context.findRenderObject()
                                            as RenderBox?;
                                        await Share.shareFiles([imgFile.path],
                                            sharePositionOrigin: box!
                                                    .localToGlobal(
                                                        Offset.zero) &
                                                box.size);
                                      },
                                      child: const Text("Teilen"),
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: Icon(Icons.share_outlined,
                            color: (Provider.of<ThemeProvider>(context)
                                        .themeMode ==
                                    ThemeMode.dark)
                                ? Colors.white
                                : Colors.black),
                      )
                    ],
                    expandedHeight: 150,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                  left: 16, top: kToolbarHeight),
                              child: Text(
                                "Hi, Rafa!",
                                textScaleFactor: 2,
                                maxLines: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 64),
                              child: AutoSizeText(
                                "F??r das Jahr 2022 verbleiben dir noch " +
                                    (_leaveDays +
                                            _restLeaveDays -
                                            leaveListOnlyPaid.length)
                                        .toString() +
                                    " Urlaubstage.",
                                maxLines: 2,
                                textScaleFactor: 1.2,
                              ),
                            ),
                          ]),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: RepaintBoundary(
                      key: genKey,
                      child: YearlyCalendar(updateHolidayDays,
                          state: state,
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
