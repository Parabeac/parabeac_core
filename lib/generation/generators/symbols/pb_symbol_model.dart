
class PBSymbolModel {
  static final PBSymbolModel _model = PBSymbolModel._internal();
  final Map<String, String> _symbols = {};

  factory PBSymbolModel() => _model;
  PBSymbolModel._internal();

  String getSymbol(String id) => _symbols[id];
  void setSymbol(String id, String value) {
    if(_symbols.containsKey(id)){
      return;
    }
    _symbols[id] = value;
  } 

}
