enum States { BW, BY, BE, BB, HB, HH, HE, MV, NI, NW, RP, SL, SN, ST, SH, TH }

extension StateString on States {
  String toLongString() {
    switch (this) {
      case States.BW:
        return "Baden-Württemberg";
      case States.BY:
        return "Bayern";
      case States.BE:
        return "Berlin";
      case States.BB:
        return "Baden-Württemberg";
      case States.HB:
        return "Bremen";
      case States.HH:
        return "Hamburg";
      case States.HE:
        return "Hessen";
      case States.MV:
        return "Mecklenburg-Vorpommern";
      case States.NI:
        return "Niedersachsen";
      case States.NW:
        return "Nordrhein-Westfalen";
      case States.RP:
        return "Rheinland-Pfalz";
      case States.SL:
        return "Saarland";
      case States.SN:
        return "Sachsen";
      case States.ST:
        return "Sachsen-Anhalt";
      case States.SH:
        return "Schleswig-Holstein";
      case States.TH:
        return "Thüringen";
    }
  }
}

extension ParseToString on States {
  String toShortString() {
    return toString().split('.').last;
  }
}
